from django.urls import path,include

from rest_framework.routers import DefaultRouter

from flood import views

from rest_framework.authtoken.views import obtain_auth_token

from rest_framework.authtoken.views import obtain_auth_token

router =DefaultRouter()
router.register('userprofile',views.UserProfileViewSet)
router.register('userpost',views.UserPostViewSet)



urlpatterns = [
    path('',include(router.urls)),
    path('login/',obtain_auth_token)
]