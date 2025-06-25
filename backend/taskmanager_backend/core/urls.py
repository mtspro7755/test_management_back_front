from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProjetViewSet, TacheViewSet

router = DefaultRouter()
router.register(r'projets', ProjetViewSet, basename='projet')
router.register(r'taches', TacheViewSet, basename='tache')

urlpatterns = [
    path('', include(router.urls)),
]

#Ajout des vues JWT
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns += [
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]

from .views import RegisterView

urlpatterns += [
    path('auth/register/', RegisterView.as_view(), name='register'),
]
