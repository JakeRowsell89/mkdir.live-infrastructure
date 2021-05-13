exports.handler = async (event) => {
    const uploadType = event.requestContext.http.path === "/static" ? "static" : "functions"
    const { uniqueNamesGenerator, colors, animals, names } = require('unique-names-generator') // This module is not my work
    const AWS = require('aws-sdk') // This module is not my work
    AWS.config.update({ region: 'eu-west-2' })
    const s3 = new AWS.S3()

    const folderName = uniqueNamesGenerator({
        dictionaries: [colors, animals, names],
        separator: '-'
    }).toLowerCase()
    const destination = uploadType === "static" ? `https://s3.eu-west-2.amazonaws.com/mkdir.live-static/${folderName}/index.html`: `https://kel4mzfc4f.execute-api.eu-west-2.amazonaws.com/api/${folderName}`

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