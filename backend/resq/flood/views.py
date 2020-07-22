from rest_framework.viewsets import ViewSet,ModelViewSet
from flood.serializer import UserPostSerializer,UserProfileSerializer
from flood.models import UserPost,UserProfile
from rest_framework.authentication import TokenAuthentication
from flood.permissions import UserProfilePermission,UserPostPermission
from rest_framework.permissions import IsAuthenticatedOrReadOnly,IsAuthenticated
from flood.pagination import UserProfilePagination
from rest_framework.views import APIView
from rest_framework.response import Response


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
        #serializer.save(upvotes=[self.request.user])
        return serializer.save(userprofile=self.request.user)
    
    # def create(self, *args, **kwargs):
    #     return UserPost.objects.create(upvotes=[self.request.user],userprofile=self.request.user,**kwargs)


    
class Upvote(APIView):
    authentication_classes=[TokenAuthentication,]
    permission_classes=[IsAuthenticated]
    def put(self,request,pk,format=None):
        obj=UserPost.objects.get(pk=pk)
        print(obj)
        print(obj.upvotes)
        print(request.user)
        if request.user not in obj.upvotes.all():
            obj.upvotes.add(request.user)
            return Response({'detail':'yes'})
        else:
            return Response({'detail':'no'})