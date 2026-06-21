// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract RegistroVerificacionTitulos
{
    // Definimos los estados posibles del título
    enum EstadoTitulo { NoExiste, Activo, Suspendido, Revocado }

    struct Titulo {
        string uuidEstudiante;   // UUID del estudiante 
        bytes32 documentoHash;   // Hash SHA-256 del documento/título
        address universidad;     // Cuenta (billetera) que registró el título
        uint256 fechaRegistro;   // Timestamp del bloque
        EstadoTitulo estado;     // Estado actual del título
    }

    // El mapeo ahora usa el UUID del estudiante como llave única
    mapping(string => Titulo) private titulos;

    // Eventos para mantener registro en la blockchain
    event TituloRegistrado(
        string uuidEstudiante, 
        bytes32 indexed documentoHash, 
        address indexed universidad
    );
    
    event TituloModificado(
        string uuidEstudiante, 
        bytes32 nuevoDocumentoHash, 
        EstadoTitulo nuevoEstado, 
        address indexed modificadoPor
    );

    // Modificador para restringir que solo la universidad dueña del registro pueda modificarlo
    modifier soloUniversidad(string memory _uuidEstudiante) {
        require(titulos[_uuidEstudiante].estado != EstadoTitulo.NoExiste, "El titulo no esta registrado");
        require(titulos[_uuidEstudiante].universidad == msg.sender, "No tienes permiso. Solo la universidad emisora puede modificarlo");
        _;
    }

    /**
     * @notice Registra un nuevo título universitario.
     */
    function registrarTitulo(
        string memory _uuidEstudiante,
        bytes32 _documentoHash
    ) public {
        // Validamos que el título no exista previamente
        require(titulos[_uuidEstudiante].estado == EstadoTitulo.NoExiste, "El estudiante ya tiene un titulo registrado");
        // Validación básica de que el UUID no esté vacío
        require(bytes(_uuidEstudiante).length > 0, "El UUID no puede estar vacio");

        titulos[_uuidEstudiante] = Titulo({
            uuidEstudiante: _uuidEstudiante,
            documentoHash: _documentoHash,
            universidad: msg.sender,
            fechaRegistro: block.timestamp,
            estado: EstadoTitulo.Activo // Se registra como Activo por defecto
        });

        emit TituloRegistrado(_uuidEstudiante, _documentoHash, msg.sender);
    }

    /**
     * @notice Permite a la universidad emisora modificar el hash del documento y/o el estado del título.
     */
    function modificarTitulo(
        string memory _uuidEstudiante,
        bytes32 _nuevoDocumentoHash,
        EstadoTitulo _nuevoEstado
    ) public soloUniversidad(_uuidEstudiante) {
        // Evitamos que vuelvan a setear el estado a NoExiste por error
        require(_nuevoEstado != EstadoTitulo.NoExiste, "Estado invalido");

        Titulo storage titulo = titulos[_uuidEstudiante];
        titulo.documentoHash = _nuevoDocumentoHash;
        titulo.estado = _nuevoEstado;

        emit TituloModificado(_uuidEstudiante, _nuevoDocumentoHash, _nuevoEstado, msg.sender);
    }

    /**
     * @notice Consulta y verifica si un documento coincide con el hash registrado para ese estudiante.
     */
    function verificarTitulo(
        string memory _uuidEstudiante, 
        bytes32 _documentoHash
    ) public view returns (bool registrado, bool documentoCoincide, EstadoTitulo estado) {
        Titulo memory titulo = titulos[_uuidEstudiante];
        
        registrado = (titulo.estado != EstadoTitulo.NoExiste);
        documentoCoincide = (titulo.documentoHash == _documentoHash);
        estado = titulo.estado;
    }

    /**
     * @notice Obtiene todos los datos almacenados de un título a partir del UUID.
     */
    function obtenerTitulo(string memory _uuidEstudiante) 
        public 
        view 
        returns (
            string memory uuidEstudiante,
            bytes32 documentoHash,
            address universidad,
            uint256 fechaRegistro,
            EstadoTitulo estado
        ) 
    {
        require(titulos[_uuidEstudiante].estado != EstadoTitulo.NoExiste, "El titulo solicitado no existe");
        Titulo memory titulo = titulos[_uuidEstudiante];
        
        return (
            titulo.uuidEstudiante,
            titulo.documentoHash,
            titulo.universidad,
            titulo.fechaRegistro,
            titulo.estado
        );
    }
}