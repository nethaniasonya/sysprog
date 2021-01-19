from django.urls import include, path
from . import views

app_name = 'app'

urlpatterns = [
    path('', views.index, name='index'),
    path('detail/<id>', views.detail, name='detail'),
    path('hapus/<id>', views.hapus, name='hapus'),
    path('tambah', views.add, name='add')
]
