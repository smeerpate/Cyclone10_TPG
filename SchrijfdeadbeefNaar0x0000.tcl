set master_path [lindex [get_service_paths master] 0]
set m_path [claim_service master $master_path ""]
master_write_32 $m_path 0x0000 0xdeadbeef
