import { network } from "hardhat";
import { keccak256, stringToHex } from "viem";

const { viem } = await network.create();


console.log("=== Desplegando contrato RegistroVerificacionTitulos ===");
const registroTitulos = await viem.deployContract("RegistroVerificacionTitulos");
console.log("Contrato desplegado en:", registroTitulos.address);
console.log("--------------------------------------------------\n");

// 2. Datos de prueba simulados
const uuidEstudiante = "6a2f7eb8-9c1a-4d3e-b81f-426614174000"; // Formato UUID string
const contenidoDocumentoOriginal = "Titulo de Grado - Ingenieria de Software 2026";

// Calculamos el hash SHA-256 del documento
const documentoHashOriginal = keccak256(stringToHex(contenidoDocumentoOriginal));

console.log("Datos iniciales:");
console.log("- UUID Estudiante:", uuidEstudiante);
console.log("- Hash Documento Original:", documentoHashOriginal);
console.log("--------------------------------------------------\n");

// 3. REGISTRAR TÍTULO
console.log("1. Ejecutando: registrarTitulo...");
const txRegistro = await registroTitulos.write.registrarTitulo([
    uuidEstudiante,
    documentoHashOriginal,
]);
console.log("   Transacción de registro enviada:", txRegistro);
console.log("--------------------------------------------------\n");

// 4. CONSULTAR / VERIFICAR TÍTULO ORIGINAL
console.log("2. Ejecutando: verificarTitulo (Validando datos originales)...");
const verificacionInicial = await registroTitulos.read.verificarTitulo([
    uuidEstudiante,
    documentoHashOriginal,
]);

// Recordar que en los enums: 0 = NoExiste, 1 = Activo, 2 = Suspendido, 3 = Revocado
console.log("   Resultado:");
console.log("   - ¿Está registrado?:", verificacionInicial[0]);
console.log("   - ¿Coincide el hash del documento?:", verificacionInicial[1]);
console.log("   - Estado actual (Enum):", verificacionInicial[2]); // Debería devolver 1 (Activo)
console.log("--------------------------------------------------\n");

// 5. MODIFICAR EL TÍTULO (Actualizar documento y cambiar estado a Suspendido)
console.log("3. Ejecutando: modificarTitulo (Simulando una actualización)...");

const contenidoDocumentoCorregido = "Titulo de Grado de Juan Perez - Ingenieria de Software 2026 (CORREGIDO)";
const nuevoDocumentoHash = keccak256(stringToHex(contenidoDocumentoCorregido));
const nuevoEstado = 2; // Representa el estado 'Suspendido' en nuestro enum

const txModificacion = await registroTitulos.write.modificarTitulo([
    uuidEstudiante,
    nuevoDocumentoHash,
    nuevoEstado
]);
console.log("   Transacción de modificación enviada:", txModificacion);
console.log("--------------------------------------------------\n");

// 6. OBTENER LOS DATOS FINALES
console.log("4. Ejecutando: obtenerTitulo (Comprobando persistencia en Blockchain)...");
const tituloFinal = await registroTitulos.read.obtenerTitulo([uuidEstudiante]);

console.log("   Datos actuales guardados en la Blockchain:");
console.log("   - UUID Estudiante (string):", tituloFinal[0]);
console.log("   - Nuevo hash del documento:", tituloFinal[1]);
console.log("   - Dirección de la Universidad:", tituloFinal[2]);
console.log("   - Fecha de registro (Timestamp):", tituloFinal[3].toString());
console.log("   - Estado actual (Enum actualizado):", tituloFinal[4]); // Debería devolver 2 (Suspendido)
console.log("==================================================");

