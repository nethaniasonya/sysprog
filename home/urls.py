from django.urls import path
from . import views

app_name = 'app'

urlpatterns = [
    path('', views.index, name='index'),
    path('detail/', views.detail, name='detail'),
    # path('hapus/', views.hapus, name='hapus'),
    # path('tambah', views.add, name='add')
]