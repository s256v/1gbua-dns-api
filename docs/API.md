## 1GB.UA API

### Account Info
curl "https://www.1gb.ua/api/billing/info?_token_=your_token_here"

### List DNS
curl "https://www.1gb.ua/api/dns/list?_token_=your_token_here"

### DNS request params
```
/dns/raw
	_key_ - /dns/list|id
	s_del = 1 to delete record, DO NOT specify ANY s_del to create record
	s_add = 1 to create record, DO NOT specify ANY s_add to delete record
	dns_type = A,MX,CNAME,AAAA,NS,TXT,SRV
	dns_name = record name or @ for root
	dns_value = record content, dnscmd.exe format (A: [ip], CNAME: [name], MX: [priority] [target])
```