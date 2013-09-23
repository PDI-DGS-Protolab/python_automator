import boto.ec2

AWSAccessKeyId = 'AKIAI52ERUQP3UL5K2QA'
AWSSecretKey = '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'

conn = boto.ec2.connect_to_region(
    'us-west-2a',
    aws_access_key_id=AWSAccessKeyId,
    aws_secret_access_key=AWSSecretKey)


def launchInstances( AMIimageId, keyName, instanceType, securityGroups ):
    conn.run_instances(
        AMIimageId,
        min_count=1, 
        max_count=1,
        key_name=keyName,
        instance_type=instanceType,
        security_groups=securityGroups )


def stopInstances( instaceIds, force=False ):
    conn.stop_instances(
        instance_ids=instaceIds,
        force=force )


def terminateInstances( instaceIds ):
    conn.terminate_instances(
        instance_ids=instaceIds )