try:
    import boto3 
    import json
    import os
    import urllib3
    import gzip
    import base64
except Exception as e:
    print("Error : {} ".format(e))

# get api key from ssm
secrets_client = boto3.client('secretsmanager')
secret_arn = os.environ['DD_API_KEY_SECRET_ARN']
auth_token = secrets_client.get_secret_value(SecretId=secret_arn).get('SecretString')

# api configuration
http = urllib3.PoolManager()
url = "https://http-intake.logs.datadoghq.com/api/v2/logs"
HEADERS = {'Content-Type': 'application/json', 'DD-API-KEY': auth_token}


# example of encrypted & compressed log
# {"awslogs": {	"data" : "H4sIAAAAAAAAADWQQW/CMAyF/0qVM1rjNE0TbpXG0A7jQNkJoSlQgyLRJkpS0IT47zOg3axn+/N7vrEBU7In3PwGZHP23m7an69F17XLBZsxfx0xklwpyUWtG65AkXz2p2X0U6BOaa+ptCHEaaTRssfBl7jXBo57gEpbqW2ttTnWQhih+l7aRpcJ48Ud8EXqckQ7EAovOOZEYpr26RBdyM6PH+6cMSY237Ljs/Qjst1zcfGan29vzPUPk00FoKQAw2vgBurGCCmk4cCFBk32oQEwgtdGVQJAioprrSRdzI7ekO1AiUA9MMTg2qjZ/3sIv21DWD9T7oruFaCgnTylwqUiYS6yL9bfq9XnavnG7rv7H/EIYFhcAQAA" }}

# lambda handler
def lambda_handler(event, context):
    log_data = event["awslogs"]["data"]
    decode_log_data = base64.b64decode(log_data)
    decompress_log_data = gzip.decompress(decode_log_data)
    total_log_data = json.loads(decompress_log_data)
    log_list = total_log_data["logEvents"]
    BODY = []
    for log in log_list:
        log["ddsource"] = "AppRunner"
        log["service"] = "AppRunnerDeployment"
        log["ddtags"] = "name:chaitanya, version:one"
        log["logGroup"] = total_log_data["logGroup"]
        log["logStream"] = total_log_data["logStream"]
        BODY.append(log)
#     print(type(BODY))
#     print(BODY)
    retresponse = http.request('POST',
                        url,
                        body = json.dumps(BODY),
                        headers = HEADERS,
                        retries = False)
    return {
        'statusCode': retresponse.status,
        'body': json.dumps(BODY),
        'event': json.dumps(event),
        'key': json.dumps(auth_token)
    }    

