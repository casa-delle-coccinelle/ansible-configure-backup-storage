configure-backup-storage
=========

Role configures host to receive data for backups.
Then it starts backing up data from that directory daily, overrides data every 7-th day.
You will usually end up with the following structure:
```
/backups
  |- server1
  |   |- application1
  |   |   |- storage
  |   |- application2
  |       |- storage1
  |       |- storage2
  |- server2
    ...
/backup-store/
  |- server1
  |   |- application1
  |   |   |- storage
  |   |       |-Mon.tar.gz
  |   |       |-Tue.tar.gz
  |   |       |-Wed.tar.gz
  |   |       |-Thu.tar.gz
  |   |       |-Fri.tar.gz
  |   |       |-Sat.tar.gz
  |   |       |-Sun.tar.gz
  |   |- application2
  |   |   |- storage1
  |   |       |-Mon.tar.gz
  |   |       |-Tue.tar.gz
  |   |       |-Wed.tar.gz
  |   |       |-Thu.tar.gz
  |   |       |-Fri.tar.gz
  |   |       |-Sat.tar.gz
  |   |       |-Sun.tar.gz
  |   |   |- storage2
  |   |       |-Mon.tar.gz
  |   |       |-Tue.tar.gz
  |   |       |-Wed.tar.gz
  |   |       |-Thu.tar.gz
  |   |       |-Fri.tar.gz
  |   |       |-Sat.tar.gz
  |   |       |-Sun.tar.gz
  |- server2
    ...
```

Role Variables
--------------

Check `defaults/main.yml`
