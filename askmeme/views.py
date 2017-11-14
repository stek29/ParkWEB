from django.shortcuts import render

def index(request):
    return render(request, 'index.html', {
            'title': 'Hey there',
            'content': 'Quick fox brown dog lazy lala',
        })
