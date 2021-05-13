exports.handler = async (event) => {
    const AWS = require('aws-sdk') // This package is not my work
    AWS.config.update({ region: 'eu-west-2' })
    const s3 = new AWS.S3()
    const Key = event.detail.requestParameters.key
    const Bucket = 'mkdir.live-functions'
    try {
        const data = await s3.getObject({
            Bucket: event.detail.requestParameters.bucketName,
            Key,
        }).promise()
        console.log('Key received ', Key,  'Bucket decided ', Bucket)
        await s3.putObject({
            Bucket,
            Key: Key.replace(/$functions\//, ''),
            Body: data.Body
        }).promise()
    } catch (e) {
        console.error(e)
        return {
            statusCode: 500,
            body: e
        }
    }
        
    
    return {
        statusCode: 200,
        body: 'some result from moving files'
    }
}