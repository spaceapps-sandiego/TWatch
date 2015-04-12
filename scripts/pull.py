#!/usr/bin/python

#    0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4


import time
from apns import APNs, Frame, Payload

feedback_connection = APNs(use_sandbox=True, cert_file='/opt/certs/twatch.crt', key_file='/opt/certs/twatch.pem')

for (token_hex, fail_time) in feedback_connection.feedback_server.items():
  print token_hex, fail_time
