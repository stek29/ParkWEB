from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def showparams(request):
    def parse(q):
        return [{ 'k': k, 'v': v } for k, v in q.items()]

    params = parse(request.GET) + parse(request.POST)

    return render(request, 'showparams.html', {
            'title': 'Привет, мир!',
            'params': params,
        })
