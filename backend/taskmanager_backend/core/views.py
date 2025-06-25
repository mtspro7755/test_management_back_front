from django.shortcuts import render
from rest_framework import viewsets, permissions
from .models import Projet, Tache
from .serializers import ProjetSerializer, TacheSerializer

# Création  de la vue d’enregistrement

from rest_framework import generics
from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny
from rest_framework.serializers import ModelSerializer


# Create your views here.
#GET, POST, UPDATE, DELETE
class ProjetViewSet(viewsets.ModelViewSet):
    serializer_class = ProjetSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # L'utilisateur ne voit que ses projets
        return Projet.objects.filter(utilisateur=self.request.user)

    def perform_create(self, serializer):
        # Associer le projet à l'utilisateur connecté
        serializer.save(utilisateur=self.request.user)


class TacheViewSet(viewsets.ModelViewSet):
    serializer_class = TacheSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # L'utilisateur ne voit que les tâches liées à ses projets
        return Tache.objects.filter(projet__utilisateur=self.request.user)

    def perform_create(self, serializer):
        # Permet de créer une tâche sur un projet appartenant à l'utilisateur
        projet = serializer.validated_data['projet']
        if projet.utilisateur != self.request.user:
            raise permissions.PermissionDenied("Vous ne pouvez pas ajouter de tâche à ce projet.")
        serializer.save()



class TacheViewSet(viewsets.ModelViewSet):
    serializer_class = TacheSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # L'utilisateur ne voit que les tâches liées à ses projets
        return Tache.objects.filter(projet__utilisateur=self.request.user)

    def perform_create(self, serializer):
        # Permet de créer une tâche sur un projet appartenant à l'utilisateur
        projet = serializer.validated_data['projet']
        if projet.utilisateur != self.request.user:
            raise permissions.PermissionDenied("Vous ne pouvez pas ajouter de tâche à ce projet.")
        serializer.save()



# Serializer pour l'enregistrement
class RegisterSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)

# Vue pour l'enregistrement
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]

