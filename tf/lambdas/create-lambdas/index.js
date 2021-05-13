exports.handler = async (event) => {
  const AWS = require("aws-sdk") // This package is not my work

  AWS.config.update({ region: "eu-west-2" })

  const lambda = new AWS.Lambda({ apiVersion: "2015-03-31" })
  const apigatewayv2 = new AWS.ApiGatewayV2()
  const ApiId = "kel4mzfc4f"
  const key = event.detail.requestParameters.key
  console.log(key)
  const lambdaParams = {
    Code: {
      S3Bucket: event.detail.requestParameters.bucketName,
      S3Key: key,
    },
    Description: "Lambda created by user uploaded code",
    Environment: {
      Variables: {},
    },
    FunctionName: key.replace(/\/upload\.zip$/, "").replace("functions/", ""),
    Handler: "function/index.handler",
    MemorySize: 256,
    Publish: true,
    Role: "arn:aws:iam::236744700502:role/lambda-uploads",
    Runtime: "nodejs14.x",
    Tags: {
      creator: "user-generated",
    },
    Timeout: 60,
    TracingConfig: {
      Mode: "Active",
    },
  }

  try {
    const integrationParams = {
      ApiId,
      IntegrationType: "AWS_PROXY",
      PayloadFormatVersion: "2.0",
    }
    const routeParams = {
      ApiId,
      RouteKey: `POST /api/${key
        .replace(/\/upload\.zip$/, "")
        .replace("functions/", "")}`,
      ApiKeyRequired: false,
      AuthorizationType: "NONE",
    }

    const fn = await lambda.createFunction(lambdaParams).promise()
    console.log(JSON.stringify(fn))
    integrationParams.IntegrationUri = fn.FunctionArn // 'arn:aws:lambda:eu-west-2:236744700502:function:fuchsia-dormouse-noni'
    const integration = await apigatewayv2
      .createIntegration(integrationParams)
      .promise()
    routeParams.Target = `integrations/${integration.IntegrationId}`
    const apiGW = await apigatewayv2.createRoute(routeParams).promise()
    console.log(integration)

    console.log(apiGW)
    var params = {
      Action: "lambda:InvokeFunction",
      FunctionName: fn.FunctionArn,
      Principal: "apigateway.amazonaws.com",
      SourceArn: `arn:aws:execute-api:eu-west-2:236744700502:${ApiId}/$default/POST/api/${fn.FunctionName}`,
      StatementId: "access-by-api-gateway-" + Date.now(),
    }
    const permissions = await lambda.addPermission(params).promise()

    console.log(permissions)
    return {
      statusCode: 201,
      body: JSON.stringify("New lambda created"),
    }
  } catch (e) {
    return {
      statusCode: 500,
      body: new Error("failed to create Lambda ", e),
    }
  }
}
