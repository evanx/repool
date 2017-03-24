# repool

Redis utility to pop from list and add to set.

<img src='https://raw.githubusercontent.com/evanx/repool/master/docs/readme/images/main.png'>


## Use case


## Configuration

See `lib/spec.js` https://github.com/evanx/repool/blob/master/lib/spec.js

```javascript
module.exports = pkg => ({
    description: pkg.description,
    env: {
        redisHost: {
            description: 'the Redis host',
            default: 'localhost'
        },
        redisPort: {
            description: 'the Redis port',
            default: 6379
        },
        redisNamespace: {
            description: 'the Redis namespace',
            default: 'repool'
        },
        popDelay: {
            description: 'pop delay',
            unit: 'ms',
            default: 2000
        },
        popTimeout: {
            description: 'pop timeout',
            unit: 'ms',
            default: 2000
        }
    },
    redisK: config => ({
        reqS: {
            key: `${config.redisNamespace}:req:s`
        },
        reqQ: {
            key: `${config.redisNamespace}:req:q`
        },
        reqH: {
            key: sha => `${config.redisNamespace}:${sha}:req:h`
        },
        busyQ: {
            key: `${config.redisNamespace}:busy:q`
        },
        reqC: {
            key: `${config.redisNamespace}:req:count:h`
        },
        errorC: {
            key: `${config.redisNamespace}:error:count:h`
        }
    })
});
```

## Docker

See `Dockerfile` https://github.com/evanx/repool/blob/master/Dockerfile
```
FROM mhart/alpine
ADD package.json .
RUN npm install --silent
ADD lib lib
ENV NODE_ENV production
CMD ["node", "lib/index.js"]
```

We can build as follows:
```shell
docker build -t repool https://github.com/evanx/repool.git
```
where tagged as image `repool`

Then for example, we can run on the host's Redis as follows:
```shell
docker run --network=host -e NODE_ENV=test repool
```
where `--network-host` connects the container to your `localhost` bridge. The default Redis host `localhost` works in that case.

Since the containerized app has access to the host's Redis instance, you should inspect the source.


## Implementation

See `lib/main.js` https://github.com/evanx/repool/blob/master/lib/main.js
```javascript
    const sha = await client.brpoplpushAsync(redisK.reqQ, redisK.busyQ, config.popTimeout);
```

Uses application archetype: https://github.com/evanx/redis-koa-app


<hr>

https://twitter.com/@evanxsummers
