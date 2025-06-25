from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Projet(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    date_creation = models.DateTimeField(auto_now_add=True)
    utilisateur = models.ForeignKey(User, on_delete=models.CASCADE, related_name='projets')

    def __str__(self):
        return self.nom


class Tache(models.Model):
    STATUT_CHOICES = [
        ('TODO', 'À faire'),
        ('IN_PROGRESS', 'En cours'),
        ('DONE', 'Terminée'),
    ]

    titre = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    statut = models.CharField(max_length=20, choices=STATUT_CHOICES, default='TODO')
    date_echeance = models.DateField(null=True, blank=True)
    projet = models.ForeignKey(Projet, on_delete=models.CASCADE, related_name='taches')
    assignee = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='taches_assignees')

    def __str__(self):
        return f"{self.titre} ({self.statut})"

