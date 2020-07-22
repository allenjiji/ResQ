from rest_framework.viewsets import ViewSet,ModelViewSet
from flood.serializer import UserPostSerializer,UserProfileSerializer
from flood.models import UserPost,UserProfile
from rest_framework.authentication import TokenAuthentication
from flood.permissions import UserProfilePermission,UserPostPermission
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from flood.pagination import UserProfilePagination


class UserProfileViewSet(ModelViewSet):
    serializer_class=UserProfileSerializer
    queryset=UserProfile.objects.all()
    permission_classes=(UserProfilePermission,)
    authentication_classes=(TokenAuthentication,)

class UserPostViewSet(ModelViewSet):
    serializer_class=UserPostSerializer
    queryset=UserPost.objects.all()
    pagination_class=UserProfilePagination
    permisssion_classes=(UserPostPermission,IsAuthenticatedOrReadOnly)
    authentication_classes=(TokenAuthentication,)
    def perform_create(self, serializer):
        return serializer.save(userprofile=self.request.user)