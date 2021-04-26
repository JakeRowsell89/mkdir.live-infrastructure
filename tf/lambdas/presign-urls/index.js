exports.handler = async (event) => {
    const uploadType = event.requestContext.http.path === "/default/static" ? "static" : "function"
    const { uniqueNamesGenerator, colors, animals, names } = require('unique-names-generator')
    const AWS = require('aws-sdk')
    AWS.config.update({ region: 'eu-west-2' })
    const s3 = new AWS.S3()

    const folderName = uniqueNamesGenerator({
        dictionaries: [colors, animals, names],
        separator: '-',
    })
    const destination = `https://s3.eu-west-2.amazonaws.com/mkdir.live-static/${folderName}/index.html`

    const presignedUrl = await s3.getSignedUrlPromise('putObject', {
        Bucket: 'mkdir.live-uploads',
        Key: `${uploadType}/${folderName}/upload.zip`,
        Expires: 3600
    })
    return {
        statusCode: 200,
        body: JSON.stringify({ presignedUrl, destination, }),
    }
}