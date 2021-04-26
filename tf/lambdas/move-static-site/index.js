exports.handler = async (event) => {
    const AWS = require('aws-sdk')
    const yauzl = require('yauzl')

    AWS.config.update({ region: 'eu-west-2' })

    const s3 = new AWS.S3()
    const Key = event.detail.requestParameters.key
    const Bucket = 'mkdir.live-static'
    const contentTypes = {
        html: 'text/html',
        css: 'text/css',
        js: 'text/javascript',
        apng: 'image/apng',
        avif: 'image/avif',
        gif: 'image/gif',
        jpg: 'image/jpeg',
        jpeg: 'image/jpeg',
        jfif : 'image/jpeg',
        pjpeg: 'image/jpeg',
        pjp	: 'image/jpeg',
        png	: 'image/png',
        svg: 'image/svg+xml',
        webp: 'image/webp',
    }
    try {
        const data = await s3.getObject({
            Bucket: event.detail.requestParameters.bucketName,
            Key,
        }).promise()
        const folder = Key.replace(/^static\//, '').replace(/\/[^\/]*$/, '') // remove static/ from the front and the last slash onwards
        await new Promise((resolve, reject) => {
            const allPromises = []
            yauzl.fromBuffer(data.Body, {lazyEntries: true}, (err, zipfile) => {
                if (err) reject(err)
                zipfile.readEntry();
                zipfile.on("entry", function (entry) {
                    if (/\/$/.test(entry.fileName)) {
                        // Skip directories, ending with '/'
                        zipfile.readEntry();
                    } else {
                        zipfile.openReadStream(entry, function (err, readStream) {
                            if (err) reject(err);
                            let acc = ''
                            // https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types#important_mime_types_for_web_developers
                            const fileName = entry.fileName.replace(/^[^\/]+\//, '') // replace `static/` and then remove wrapper folder name
                            const fileExtension = fileName.split('.').pop()
                            const ContentType = contentTypes[fileExtension] ? { ContentType: contentTypes[fileExtension] } : {}
                            
                            readStream.on("end", function() {
                                allPromises.push(s3.putObject({
                                    Bucket,
                                    Key: `${folder}/${fileName}`,
                                    Body: Buffer.from(acc),
                                    ...ContentType
                                }).promise())
                                acc = ''
                                zipfile.readEntry();
                              });

                            readStream.on('data', function (chunk) {
                                acc += chunk
                            })
                            
                        });
                    }
                });
                zipfile.on('end', () => {Promise.all(allPromises).then(resolve).catch(reject) })
            })
        })
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
