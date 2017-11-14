# Сетап
- nginx поднят на 8080 порту, gunicorn на 8090
- все поднято на виртуалке с арчем
- измерения производятся с хоста, в 20 потоков, 500 соединений, на протяжений
  20 секунд
- в качестве динамики используется простейший wsgi скрипт из задания 2.3
- в качетве статики -- рыба на ~27 килобайт

# Результаты

### Отдача статики без proxy_cache
```
❯ wrk -t20 -c500 http://192.168.56.101:8080/static_nocache/loremie.html
Running 10s test @ http://192.168.56.101:8080/static_nocache/loremie.html
  20 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   218.77ms  150.18ms   1.91s    89.81%
    Req/Sec   119.42     81.25   252.00     56.43%
  4276 requests in 10.10s, 112.74MB read
  Socket errors: connect 0, read 0, write 0, timeout 36
Requests/sec:    423.22
Transfer/sec:     11.16MB
```

### Отдача статики с proxy_cache
```
❯ wrk -t20 -c500 http://192.168.56.101:8080/loremie.html
Running 10s test @ http://192.168.56.101:8080/loremie.html
  20 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   160.31ms   75.13ms   1.94s    94.17%
    Req/Sec   128.29     75.33   320.00     59.52%
  4954 requests in 10.10s, 130.94MB read
  Socket errors: connect 0, read 0, write 0, timeout 49
Requests/sec:    490.44
Transfer/sec:     12.96MB
```

### Динамика, nginx, без proxy_cache
```
❯ wrk -t20 -c500 'http://192.168.56.101:8080/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew'
Running 10s test @ http://192.168.56.101:8080/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew
  20 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   377.89ms  339.81ms   1.93s    86.43%
    Req/Sec    34.72     29.63   252.00     79.10%
  5061 requests in 10.09s, 1.33MB read
  Socket errors: connect 0, read 16861, write 0, timeout 219
Requests/sec:    501.80
Transfer/sec:    135.25KB
```

### Динамика, gunicorn напрямую
```
❯ wrk -t20 -c500 'http://192.168.56.101:8090/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew'
Running 10s test @ http://192.168.56.101:8090/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew
  20 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   270.70ms  158.24ms   1.53s    87.21%
    Req/Sec    34.28     42.19   250.00     86.37%
  2572 requests in 10.10s, 743.47KB read
  Socket errors: connect 0, read 0, write 0, timeout 344
Requests/sec:    254.61
Transfer/sec:     73.60KB
```

### Динамика, nginx, с proxy_cache
```
❯ wrk -t20 -c500 'http://192.168.56.101:8080/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew'
Running 10s test @ http://192.168.56.101:8080/?q=weEEEEE&EE=EEEE&EWE=WEewwewewew
  20 threads and 500 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   115.34ms   95.20ms   1.97s    94.11%
    Req/Sec   135.08     86.10   550.00     71.32%
  26117 requests in 10.08s, 8.22MB read
  Socket errors: connect 0, read 554, write 0, timeout 216
  Non-2xx or 3xx responses: 26117
Requests/sec:   2590.17
Transfer/sec:    834.72KB
```