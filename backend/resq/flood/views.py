from rest_framework.viewsets import ViewSet,ModelViewSet
from flood.serializer import UserPostSerializer,UserProfileSerializer
from flood.models import UserPost,UserProfile
from rest_framework.authentication import TokenAuthentication
from flood.permissions import UserProfilePermission,UserPostPermission
from rest_framework.permissions import IsAuthenticatedOrReadOnly,IsAuthenticated
from flood.pagination import UserProfilePagination
from rest_framework.views import APIView
from rest_framework.response import Response
from math import sin, cos, sqrt, atan2, radians
from decimal import Decimal
from django.shortcuts import get_object_or_404
from rest_framework import filters
from django_filters.rest_framework import DjangoFilterBackend

class UserProfileViewSet(ModelViewSet):
    serializer_class=UserProfileSerializer
    queryset=UserProfile.objects.all()
    permission_classes=(UserProfilePermission,)
    authentication_classes=(TokenAuthentication,)

    def get_queryset(self):
        #obj=self.get_object()
        queryset=UserProfile.objects.all()
        lat=self.request.query_params.get('lat',None)
        lon=self.request.query_params.get('lon',None)
        if lat is not None and lon is not None:
            return [x for x in queryset if self.get_near(Decimal(lat),Decimal(lon),x.lat,x.lon)]
        else:
            return queryset

    def get_near(self,lat1,lon1,lat2,lon2):
        R = 6373.0

        dlon = lon2 - lon1
        dlat = lat2 - lat1

        a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return (R * c)<=60

class UserPostViewSet(ModelViewSet):
    serializer_class=UserPostSerializer
    queryset=UserPost.objects.all()
    permission_classes=(IsAuthenticatedOrReadOnly,UserPostPermission,)
    authentication_classes=(TokenAuthentication,)
    pagination_class=UserProfilePagination


    filter_backends = [filters.OrderingFilter,DjangoFilterBackend,]
    filterset_fields =['isAnnouncement','isDonate','isRequest']
    ordering_fields = ['creationtime', 'upvotes']

    def perform_create(self, serializer):
        #serializer.save(upvotes=[self.request.user])
        return serializer.save(userprofile=self.request.user)

    def get_queryset(self):
        # ob=self.request.query_params.get('orderby',None)
        # typ=self.request.query_params.get('typ',None)
        # if ob is not None and typ is not None:
        #     queryset=UserPost.objects.
        queryset=UserPost.objects.all()
        lat=self.request.query_params.get('lat',None)
        lon=self.request.query_params.get('lon',None)
        if lat is not None and lon is not None:
            return [x for x in queryset if self.get_near(Decimal(lat),Decimal(lon),x.lat,x.lon)]
        else:
            return queryset

    def get_near(self,lat1,lon1,lat2,lon2):
        R = 6373.0

        dlon = lon2 - lon1
        dlat = lat2 - lat1

        a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return (R * c)<=60
 
class Upvote(APIView):
    authentication_classes=[TokenAuthentication,]
    permission_classes=[IsAuthenticated,]

    def get(self,request,pk,format=None):
        obj=UserPost.objects.get(pk=pk)
        list=[x.id for x in obj.upvotes.all()]
        return Response({'length':len(obj.upvotes.all()),'list':list})

    def put(self,request,pk,format=None):
        obj=UserPost.objects.get(pk=pk)
        if request.user not in obj.upvotes.all():
            obj.upvotes.add(request.user)
            return Response({'detail':'yes'})
        else:
            return Response({'detail':'no'})

    def delete(self,request,pk,format=None):
        obj=UserPost.objects.get(pk=pk)
        if request.user in obj.upvotes.all():
            obj.upvotes.remove(request.user)
            return Response({'detail':'yes'})
        else:
            return Response({'detail':'no'})