import datetime
import time
import json
import socket
from random import randint

#################
# Dict for logs #
#################

severity = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL', 'EMERGENCY']

url = ['http://my.website_1.com/path/number/1/?query=param_1&var=foo_1', 
		'http://my.website_1.com/path/number/2/?query=param_2&var=foo_2', 
		'http://my.website_1.com/path/number/3/?query=param_1&var=foo_2', 
		'http://my.website_1.com/path/number/3/?query=param_2&var=foo_1', 
		'http://my.website_2.com/path/number/1/?query=param_1&var=foo_1', 
		'http://my.website_2.com/path/number/2/?query=param_2&var=foo_2', 
		'http://my.website_2.com/path/number/3/?query=param_1&var=foo_2', 
		'http://my.website_2.com/path/number/3/?query=param_2&var=foo_1']

user_agent = [
	'Mozilla/5.0%2520(Windows%2520NT%25206.1;%2520Win64;%2520x64)%2520AppleWebKit/537.36%2520(KHTML,%2520like%2520Gecko)%2520Chrome/67.0.3396.99%2520Safari/537.36',
	'Mozilla/5.0%2520(X11;%2520Linux%2520x86_64;%2520rv:60.0)%2520Gecko/20100101%2520Firefox/60.0',
	'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.1 Safari/605.1.15',
	'Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)']

user = ['John', 'Jane', 'Bob', 'Alice']

status_code = ['200','401', '403', '404', '500', '503', '504']

#############
# Functions #
#############

def random_value(array):
	return array[randint(0, len(array) - 1)]

def write_text_log(filename):
	now = datetime.datetime.now()
	response_time_s = str(randint(0,10000)*1000)
	log = str(now) + ' ' + random_value(severity) + ' ' + random_value(user) \
	+ ' connected to ' + random_value(url) \
	+ ' it took ' + response_time_s \
	+ ' s and ended up with the ' + random_value(status_code) + ' status code' \
	+ ' user agent used was ' + random_value(user_agent) + '\n'
	with open(filename, 'a') as f:
			f.write(log )


def write_json_log(filename):
	now = datetime.datetime.now()
	with open(filename, 'a') as f:
			response_time = randint(0,10000)
			log = {
			"my_date": "{}" .format(str(now)),
			"response_time": response_time, 
			"severity": "{}" .format(random_value(severity)), 
			"url": "{}" .format(random_value(url)), 
			"user": "{}" .format(random_value(user)), 
			"message": "A user connected to a URL",
			"status_code": "{}" .format(random_value(status_code)),
			"user_agent": "{}".format(random_value(user_agent))}
			f.write(json.dumps(log) +'\n')
	
		
def dummy():
	print('Dummy script started\n')
	print('text_log.log file path is /vagrant/text_log.log')
	print('json_log.log file path is /vagrant/json_log.log')
	while(1):
		write_text_log('./text_log.log')
		write_json_log('./json_log.log')
		time.sleep(3)

if __name__ == '__main__':
	dummy()
