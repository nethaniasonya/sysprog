from django.shortcuts import render

# Create your views here.
def index(request):
    return render(request, 'index.html')

def detail(request):
    return render(request, 'detail.html')

# def detail(request, id):
#     berat = Entry.objects.get(id=id)
#     context = {
#         'data': berat,
#     }
#     return render(request, 'detail.html', context)