a = File.open('/Users/pheno/Documents/os/disk.img', 'rb')
$disk = IO.binread(a)
jmp = get_hex_to_i(0, 3)
oem = get_hex_to_i(3, 8)
no_bytes_in_sector = get_hex_to_i(11, 2)  # number of bytes per sector (remember, all numbers are in the little-endian format). "\x00\x02" 512 bytes
no_sectors_in_cluster = get_hex_to_i(13, 1) # cluster- contiguous area of disk storage
no_reserved_sectors = get_hex_to_i(14, 2) # 1
no_fat = get_hex_to_i(16, 1) # 2
no_directory_entries = get_hex_to_i(17, 2) # 0x2000 = 512
total_sectors = get_hex_to_i(19, 2) # 0x1000 = 4096 = 2^12
media_descriptor_type = get_hex_to_i(21, 1)
no_sectors_per_fat = get_hex_to_i(22, 2) # 3
no_sector_per_track = get_hex_to_i(24, 2) # 32
no_heads_on_storage = get_hex_to_i(26, 2)
no_hidden_sectors = get_hex_to_i(28, 4)
large_amount_sector = get_hex_to_i(32, 4)
drive_no = get_hex_to_i(36, 1)
flags = get_hex_to_i(37, 1)
signature = get_hex_to_i(38, 1)
serial_no = get_hex_to_i(39, 4)
volume_label_str = get_hex_to_i(54, 8)
bootcode = get_hex_to_i(62, 448)
bootable_partition_signature = get_hex_to_i(510, 2)
fat_start = 512
root_start = no_bytes_in_sector * (no_reserved_sectors + no_sectors_per_fat * no_fat + no_hidden_sectors) # 7 * 512
root_directory_size = no_directory_entries * 32
cluster_start = root_start + root_directory_size
cluster_size = no_sectors_in_cluster * no_bytes_in_sector # 2048 = 4 * 512

def get_hex_to_i(start, char_len)
  if char_len == 1
    Integer("0x" + $disk[start, char_len].unpack("H*").first)
  else
    $disk[start, char_len].unpack('s').first
  end
end

def get_hex_to_s(start, char_len)
  begin
    $disk[start, char_len].unpack('s*').map(&:chr).join
  rescue
    ""
  end
end

def push_long_filename_entry(start)
  $filename_stack << [ get_hex_to_i(start, 1),
    get_hex_to_s(start + 1, 10) + get_hex_to_s(start + 14, 12) + get_hex_to_s(start + 28, 4)
  ]
end

$filename_stack = []
$directory_stack = []

def get_file_entries(start, root_directory_size)
  directory_end = start + root_directory_size
  while start < directory_end
    $directory_stack << get_file_entry(start)
    start += 32
  end

  $directory_stack.compact!
end

def get_file_entry(start)
  return if get_hex_to_i(start, 1) == 0
  attribute_code = get_hex_to_i(start + 11, 1)

  if attribute_code == 15
    push_long_filename_entry(start)
    return
  end

  filename = $filename_stack.sort { |a| a[0] }.map { |a| a[1] }.join
  $filename_stack = []

  time_to_create = get_hex_to_i(start + 12, 1)
  creation_time = get_hex_to_i(start + 14, 2)
  creation_date = get_hex_to_i(start + 16, 2)
  last_accessed_date = get_hex_to_i(start + 18, 2)
  last_modified_time = get_hex_to_i(start + 22, 2)
  last_modified_date = get_hex_to_i(start + 24, 2)
  cluster_low_16_bits = get_hex_to_i(start + 26, 2)
  file_size = get_hex_to_i(start + 28, 4)

  children = []

  attribute_message = {
    '1': 'read_only',
    '2': 'hidden',
    '4': 'system',
    '8': 'volume_id',
    '16': 'directory',
    '32': 'archive'
  }[attribute_code.to_s]

  entry = {
    file_name: filename,
    time_to_create: time_to_create,
    creation_time: creation_time,
    creation_date: creation_date,
    last_accessed_date: last_accessed_date,
    last_modified_time: last_modified_time,
    last_modified_date: last_modified_date,
    attribute_message: attribute_message,
    attribute_code: attribute_code,
    children: children
  }
end



# https://support.microsoft.com/en-us/help/140418/detailed-explanation-of-fat-boot-sector

# 512 boot code + 3 sectors per fat, 2 fats, 512 bytes from sector
