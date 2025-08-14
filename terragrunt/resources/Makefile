SEARCH_PATH := .
FILES_TO_DELETE := provider.tf remotebackend.tf .terraform.lock.hcl .terragrunt-cache backend.tf
DIRS_TO_DELETE := .terraform

#Detectar el workspace actual
CURRENT_WORKSPACE := $(shell $(TERRAGRUNT_CMD) workspace show 2>/dev/null || echo unknown)

# --- Funciones principales ---

.PHONY: clean


clean:
	@echo "Iniciando limpieza..."
	@echo "Eliminando archivos: $(FILES_TO_DELETE)"
	@find $(SEARCH_PATH) -type f \( -name "provider.tf" -o -name "remotebackend.tf" -o -name ".terraform.lock.hcl" -o -name "backend.tf" -o -name ".terragrunt-cache" \) -delete
	@echo "Eliminando directorios: $(DIRS_TO_DELETE)"
	@find $(SEARCH_PATH) -type d -name ".terraform" -exec rm -rf {} +
	@echo "Limpieza completada."


# --- Ayuda ---

help:
	@echo ""
	@echo "Uso: make <target>"
	@echo ""
	@echo "Targets disponibles:"
	@echo "  clean:         Elimina archivos y directorios generados por Terraform/Terragrunt como .terraform, terraform.tfstate, y otros."

.DEFAULT_GOAL := help