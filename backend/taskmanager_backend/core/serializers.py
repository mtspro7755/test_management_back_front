from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Projet, Tache


# Serializer pour l'utilisateur (lecture seule)
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username']


# Serializer pour les tâches
class TacheSerializer(serializers.ModelSerializer):
    assignee = UserSerializer(read_only=True)
    assignee_id = serializers.PrimaryKeyRelatedField(
        queryset=User.objects.all(), source='assignee', write_only=True, required=False
    )

    class Meta:
        model = Tache
        fields = ['id', 'titre', 'description', 'statut', 'date_echeance', 'projet', 'assignee', 'assignee_id']


# Serializer pour les projets avec tâches imbriquées
class ProjetSerializer(serializers.ModelSerializer):
    utilisateur = UserSerializer(read_only=True)
    taches = TacheSerializer(many=True, read_only=True)

    class Meta:
        model = Projet
        fields = ['id', 'nom', 'description', 'date_creation', 'utilisateur', 'taches']
