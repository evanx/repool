
set -u -e

  pattern=repool:* command=del rescan
  redis-cli del repool:req:q
  redis-cli del repool:busy:q
  redis-cli del repool:1:req:h
  redis-cli hset repool:1:req:h text 'another test message'
  redis-cli lpush repool:req:q 1
  redis-cli lpush repool:req:q exit
