class Integer
  def to_bytes
    self * 512 # bytes_per_sector
  end
end

class String
  def hex_to_i
    if self.length == 1
      Integer("0x" + self.unpack("H*").first)
    else
      self.unpack('s*').first
    end
  end
end

class FAT12Driver
  attr_accessor :disk

  def initialize(disk_path)
    @disk = IO.binread(File.open(disk_path, 'rb'))
  end

  def bios_parameter_block
    {

    }
  end

  def jmp
    disk[0, 3]
  end

  def oem
    disk[3, 8]
  end

  def bytes_per_sector
    disk[11, 2].hex_to_i
  end

  def sectors_per_cluster
    disk[13, 1].hex_to_i
  end

  def reserved_sectors_count
    disk[14, 2].hex_to_i
  end

  def fat_table_count
    disk[16, 1].hex_to_i
  end

  def root_directory_entries_count
    disk[17, 2].hex_to_i
  end

  def total_small_sectors_count
    disk[19, 2].hex_to_i
  end

  def media_descriptor_type
    disk[21, 1] # \xF8 fixed, non-removable media
  end

  def sectors_per_fat_table
    disk[22, 2].hex_to_i
  end

  def sectors_per_track
    disk[24, 2].hex_to_i
  end

  def heads_per_storage
    disk[26, 2].hex_to_i
  end

  def hidden_sectors_count
    disk[28, 4].hex_to_i
  end

  def total_large_sectors_count
    disk[32, 4].hex_to_i
  end

  def drives_count
    disk[36, 1].hex_to_i
  end

  def flags
    disk[37, 1].hex_to_i
  end

  def signature
    disk[38, 1].hex_to_i
  end

  def serial_no
    disk[39, 4]
  end

  def volume_label
    disk[54, 8]
  end

  def bootcode
    disk[62, 448]
  end

  def bootable_partition_signature
    disk[510, 2]
  end

  def fat_volume_type
    if total_clusters_count < 4085
      'FAT12'
    elsif total_clusters_count < 65525
      'FAT16'
    else
      'FAT32'
    end
  end

  def total_sectors_count
    total_small_sectors_count == 0 ? total_large_sectors_count : total_small_sectors_count
  end

  def total_clusters_count
    total_sectors_count / sectors_per_cluster
  end

  def total_bytes_count
    total_sectors_count * bytes_per_sector
  end

  def fat_table_start_in_sectors
    reserved_sectors_size_in_sectors
  end

  def root_directory_start_in_sectors
    fat_table_start_in_sectors + fat_table_size_in_sectors
  end

  def data_start_in_sectors
    root_directory_start_in_sectors + root_directory_size_in_sectors
  end

  def reserved_sectors_size_in_sectors
    reserved_sectors_count + hidden_sectors_count
  end

  def fat_table_size_in_sectors
    sectors_per_fat_table * fat_table_count
  end

  def root_directory_size_in_sectors
    root_directory_entries_count * 32 / bytes_per_sector
  end

  def data_size_in_sectors
    total_sectors_count -
      reserved_sectors_size_in_sectors -
      fat_table_size_in_sectors -
      root_directory_size_in_sectors
  end

  def sector_start_for_nth_cluster(n)
    data_start_in_sectors + sectors_per_cluster * (n - 2) # fucking clusters start at 2 wtf
  end

  def ls

  end

  def cat()

  end

  def stat()

  end
end
