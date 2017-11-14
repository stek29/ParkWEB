"""
gunicorn hw:sum_app -b 0.0.0.0:8081
"""
from urllib import parse

CHARSET = 'utf-8'
XFORM = 'application/x-www-form-urlencoded'

def sum_app(environ, start_response):
    """Simplest possible application object"""
    status = '200 OK'
    response_headers = [
        ('Content-type', f'text/plain; charset={CHARSET}'),
    ]
    start_response(status, response_headers)

    method = environ['REQUEST_METHOD']
    yield '\n'.join([
            'Привет Мир!',
            f'Метод: {method}',
            ''
    ]).encode(CHARSET)

    params = None

    if method == 'GET':
        params = parse.parse_qs(environ['QUERY_STRING'])
    elif method == 'POST' and environ['CONTENT_TYPE'] == XFORM:
        params = parse.parse_qs(
                environ['wsgi.input'].read().decode(CHARSET))

    if params is None:
        return 'Не могу распарсить параметры!\n'.encode(CHARSET)

    yield 'Параметры:\n'.encode(CHARSET)
    for k, v in params.items():
        yield f'{k}: {", ".join(v)}\n'.encode(CHARSET)

    return 'Bye!'.encode(CHARSET)

