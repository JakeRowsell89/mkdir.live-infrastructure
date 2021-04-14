exports.handler = async (event) => {
    const AWS = require('aws-sdk')
    AWS.config.update({ region: 'eu-west-2' })
    const s3 = new AWS.S3()
    const presignedUrl = await s3.getSignedUrlPromise('putObject', {
        Bucket: 'mkdir.live-uploads',
        Key: 'folder/file1.gz',
        Expires: 3600
    })
    return {
        statusCode: 200,
        body: JSON.stringify({ presignedUrl })
    }
}