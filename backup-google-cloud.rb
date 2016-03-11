require 'date'

ARCHIVE = 30 # Days
DISKS   = ["disk-2-srvtest01", "srvtest01"] # The names of the disks to snapshot
FORMAT  = '%y%m%d'

today = Date.today
date = today.strftime(FORMAT).to_i
limit = (today - ARCHIVE).strftime(FORMAT).to_i

# Backup
`yes | gcloud compute disks snapshot #{DISKS.join(' ')} --snapshot-names #{DISKS.join("-#{date},")}-#{date}`

# Rotate
snapshots = []
`gcloud compute snapshots list`.split("\n").each do |row|
  name = date
  row.split("\s").each do |cell|
    name = cell
    break
  end
  next if name == 'NAME'
  snapshots << name if name[-6, 6].to_i < limit
end
`yes | gcloud compute snapshots delete #{snapshots.join(' ')}` if snapshots.length > 0

