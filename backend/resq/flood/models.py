from django.db import models

from django.contrib.auth.models import AbstractBaseUser,PermissionsMixin,BaseUserManager


class UserProfileManager(BaseUserManager):
    def create_user(self,*args, **kwargs):
        if all(x in kwargs.keys() for x in ['phone','is_volunteer','lat','lon']):
            user=self.model(**kwargs)
            user.set_password(kwargs['password'])
            user.save(using=self._db)
            return user
        else:
            return ValueError('Some values are mandatory')

    def create_superuser(self,phone,lat,lon,is_volunteer,password):
        #print([phone,lat,lon,is_volunteer,password])
        user=self.create_user(phone=phone,lat=lat,lon=lon,is_volunteer= is_volunteer,password= password)
        user.is_superuser=True
        user.is_staff=True
        print(user)
        user.save(using=self._db)

        return user
        


class UserProfile(AbstractBaseUser,PermissionsMixin):
    #email=models.EmailField(max_length=40,unique=True)
    phone=models.CharField(max_length=10,unique=True,)
    name=models.CharField(max_length=30)
    is_volunteer=models.BooleanField()
    district=models.CharField(max_length=30,null=True)
    areaofvol=models.CharField(max_length=40,null=True)
    address=models.CharField(max_length=200,null=True)
    lat=models.DecimalField(max_digits=9,decimal_places=6)
    lon=models.DecimalField(max_digits=9,decimal_places=6)

    REQUIRED_FIELDS=['lat','lon','is_volunteer']

    USERNAME_FIELD ='phone'

    objects=UserProfileManager()

    def __str__(self):
        return self.phone



class UserPostManager(models.Manager):
    def create(self,*args, **kwargs):
        if all(x in kwargs.keys() for x in['userprofile','lat','lon','content','heading']):
            userp=self.model(**kwargs)
            userp.save(using=self._db)
            # userp.upvotes.set([])
            # userp.save()
            return userp
            #return super(UserPostManager,self).create(*args, **kwargs)
        else:
            return ValueError('Some values are mandatory')


class UserPost(models.Model):
    userprofile=models.ForeignKey(UserProfile,on_delete=models.CASCADE)
    upvotes=models.ManyToManyField(UserProfile,related_name='luserprofile',blank=True)
    lat=models.DecimalField(max_digits=9,decimal_places=6)
    lon=models.DecimalField(max_digits=9,decimal_places=6)
    heading=models.TextField(max_length=100)
    content=models.TextField(max_length=350)
    contactphn=models.CharField(max_length=10)
    image=models.ImageField(upload_to='images/',blank=True)
    creationtime=models.DateTimeField(auto_now_add=True)
    isRequest=models.BooleanField(default=False)
    isDonate=models.BooleanField(default=False)
    isAnnouncement=models.BooleanField(default=False)
    isFoodWater=models.BooleanField(default=False)
    isToiletries=models.BooleanField(default=False)
    isOther=models.BooleanField(default=False)
    isRescue=models.BooleanField(default=False)

    REQUIRED_FIELDS=['userprofile','lat','lon','heading','content','contactphn']

    objects=UserPostManager()

    def __str__(self):
        return self.content