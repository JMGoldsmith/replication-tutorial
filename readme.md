$NODE_NAME - hostname
$CONSUL_DATA_PATH - hardcode?
$ADVERTISE_ADDR - self IP
"$JOIN1", "$JOIN2", "$JOIN3" - IP from ip.


notes from single instance setup
- Make certs - done
- set up agent.
sudo systemctl enable consul.service
sudo systemctl start consul.service
sudo systemctl status consul.service