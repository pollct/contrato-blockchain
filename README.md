# 🎓 Registro de Títulos Universitarios en Blockchain

Este repositorio contiene una solución descentralizada basada en un contrato inteligente de **Solidity** para la emisión, auditoría, modificación y control de estados de títulos académicos sobre la EVM. La infraestructura de desarrollo y ejecución de pruebas está completamente automatizada utilizando **TypeScript**, **Hardhat**, **Viem** y **Docker**.

---

## 🚀 1. Guía de Ejecución con Docker

Para facilitar la evaluación del proyecto sin necesidad de configurar dependencias de Node.js, compiladores de Solidity (`solc`) o redes locales de prueba en su sistema, todo el entorno ha sido empaquetado en una imagen pública de Docker Hub que automatiza todo el flujo.

### 📋 Requisitos Previos
* Tener instalado **Docker Desktop** (en Windows o macOS) o el motor de Docker (en Linux).
* Asegurarse de que el servicio de Docker esté iniciado y corriendo en segundo plano.

### 💻 Ejecución Inmediata (Modo Evaluador)
Para descargar la imagen pública desde Docker Hub y ejecutar de manera automática el flujo completo de compilación, despliegue local en memoria y pruebas del contrato inteligente, ejecute el siguiente comando en su terminal:

```bash
docker run --rm pollct/registro-verificacion-titulos:latest
