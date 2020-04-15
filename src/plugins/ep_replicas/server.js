const redisAdapter = require('socket.io-redis');
const Redis = require('ioredis');

exports.redisSentinelAdapter = function(hook_name, args, cb) {
  const options = {
    sentinels: [{host: 'redis-sentinel', port: 26379}],
    name: 'sauron',
  };

  args.io.adapter(
    redisAdapter({
      pubClient: new Redis(options),
      subClient: new Redis(options),
    }),
  );
};