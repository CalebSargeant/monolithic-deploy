for i in $(curl https://www.google.com/supported_domains | sed 's/.//'); do
  echo "216.239.38.120 www.$i"
  echo "216.239.38.120 $i"
done | tee google-domains-safe-search.list
