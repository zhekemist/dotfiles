let
  disk =
    { id, partitions }:
    {
      type = "disk";
      device = "/dev/disk/by-id/${id}";
      content = {
        type = "gpt";
        inherit partitions;
      };
    };
  encryptedZfsPartition =
    { name, pool }:
    {
      size = "100%";
      content = {
        type = "luks";
        inherit name;
        settings.allowDiscards = true;
        content = {
          type = "zfs";
          inherit pool;
        };
      };
    };
  zfsDataset =
    {
      mountpoint,
      snapshots ? false,
      postCreateHook ? null,
    }:
    {
      type = "zfs_fs";
      inherit mountpoint;
      options."com.sun:auto-snapshot" = if snapshots then "true" else "false";
      ${if postCreateHook != null then "postCreateHook" else null} = postCreateHook;
    };
in
{
  disko.devices.disk.small-disk = disk {
    id = "ata-MTFDDAV256TBN-1AR15ABHA_UFZNP01ZRA0H9F";
    partitions = {
      ESP = {
        size = "1G";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [
            "umask=0077"
            "defaults"
          ];
        };
      };
      luks = encryptedZfsPartition {
        name = "crypted0";
        pool = "zroot";
      };
    };
  };

  disko.devices.disk.large-disk = disk {
    id = "ata-Samsung_SSD_870_QVO_1TB_S5RRNF0RB02972E";
    partitions = {
      luks = encryptedZfsPartition {
        name = "crypted1";
        pool = "zroot";
      };
    };
  };

  disko.devices.zpool.zroot = {
    type = "zpool";
    options = {
      ashift = "12";
    };
    rootFsOptions = {
      acltype = "posix";
      atime = "off";
      canmount = "off";
      compression = "zstd";
      dnodesize = "auto";
      mountpoint = "none";
      normalization = "formD";
      xattr = "sa";
    };
    datasets = {
      "root" = zfsDataset {
        mountpoint = "/";
        postCreateHook = "zfs snapshot zroot/root@blank";
      };
      "nix" = zfsDataset { mountpoint = "/nix"; };
      "state" = zfsDataset { mountpoint = "/state"; };
      "persist" = zfsDataset {
        mountpoint = "/persist";
        snapshots = true;
      };
    };
  };
}
