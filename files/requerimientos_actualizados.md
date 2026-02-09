# Especificación de Requerimientos - BarberShop iOS
## Documento Actualizado - Sin Sistema de Pagos

**Versión:** 2.0  
**Fecha:** 08 de Febrero, 2026  
**Nota:** Los pagos se realizan directamente en la barbería. No se requiere procesamiento de pagos en la aplicación.

---

## REQUERIMIENTOS FUNCIONALES

| ID | Requerimiento | Descripción | Prioridad | Módulo/Servicio |
|----|---------------|-------------|-----------|-----------------|
| **RF01** | Registro de Usuario | El sistema permitirá registrar clientes, usando Supabase Auth. | Alta | Auth Service |
| **RF02** | Inicio de Sesión | Los usuarios podrán iniciar sesión con correo/contraseña o provider. | Alta | Auth Service |
| **RF03** | Cierre de Sesión | El usuario podrá cerrar sesión. | Alta | Auth Service |
| **RF04** | Recuperación de Contraseña | El usuario podrá solicitar restablecimiento de contraseña desde la misma app. | Media | Auth Service |
| **RF05** | Edición de Perfil | Actualización de datos personales, imagen, teléfono y preferencias. | Alta | User Service |
| **RF06** | Gestión de Barberías | Ver listado y detalle de barberías con horarios, ubicación y servicios. | Alta | Catalog Service |
| **RF07** | Gestión de Servicios | Mostrar servicios por barbería: precio, duración, descripción. | Alta | Catalog Service |
| **RF08** | Gestión de Barberos | Listar barberos asociados con especialidades y rating. | Alta | Staff Service |
| **RF09** | Disponibilidad de Barbero | Consultar turnos disponibles según fecha, barbería y barbero. | Alta | Staff Service |
| **RF10** | Agendar Cita | El cliente podrá agendar una cita seleccionando barbero, servicio y turno libre. | **Crítica** | Booking Service |
| **RF11** | Cancelar Cita | Cancelar citas según políticas (tiempo mínimo permitido). | Alta | Booking Service |
| **RF12** | Reagendar Cita | Cambiar horario según disponibilidad. | Media | Booking Service |
| **RF13** | Ver Citas (Usuario) | Mostrar historial, citas pendientes y completadas. | Alta | Booking Service |
| **RF14** | Ver Agenda (Barbero) | El barbero podrá ver su agenda diaria/semanal. | Alta | Booking Service |
| **RF17** | Gestión de Reseñas | Crear, ver y listar reseñas de barberías/barberos. | Media | Reviews Service |
| **RF18** | Notificaciones Push | Enviar notificaciones de confirmación, recordatorios y cancelaciones. | Alta | Notification Service |
| **RF19** | Chat Usuario–Barbería | Mensajería en tiempo real entre el cliente y la barbería. | Media | Messaging Service |
| **RF20** | Subida de Archivos | Permitir subir imágenes (avatar, fotos de estilo) a Supabase Storage. | Media | Media Service |
| **RF21** | Gestión Administrativa | CRUD de barberías, servicios, horarios, promociones y barberos. | Media | Admin Service |
| **RF22** | Geolocalización | Mostrar barberías cercanas usando coordenadas GPS. | Media | Catalog Service |
| **RF23** | Filtrado y Búsquedas | Búsqueda por nombre, servicio, precio, rating o distancia. | Media | Catalog Service |
| **RF24** | Registro de Actividad | Guardar logs de operaciones críticas (reservas, cambios de estado). | Alta | Audit Service |
| **RF25** | Integración con Calendario iOS | Agregar citas confirmadas al calendario nativo del usuario. | Baja | iOS Client |

---

## REQUERIMIENTOS NO FUNCIONALES

| ID | Requerimiento | Descripción | Tipo | Prioridad |
|----|---------------|-------------|------|-----------|
| **RNF01** | Seguridad JWT | Todo acceso backend debe realizarse mediante JWT generado por Supabase Auth. | Seguridad | Alta |
| **RNF02** | Políticas RLS | Todas las tablas sensibles deben tener Row Level Security activadas. | Seguridad | Alta |
| **RNF03** | Comunicación HTTPS | Todo intercambio de datos debe ser cifrado mediante HTTPS/TLS 1.2+. | Seguridad | Alta |
| **RNF04** | Prevención de Doble Reserva | Debe tenerse transacción ACID al crear citas y marcar turnos. | Integridad | **Crítica** |
| **RNF05** | Escalabilidad Horizontal | Los microservicios deben ejecutarse en contenedores escalables. | Arquitectura | Media |
| **RNF06** | Disponibilidad | El sistema debe estar disponible 99.5% del tiempo. | Arquitectura | Alta |
| **RNF07** | Recuperación de Fallos | Respaldos diarios automáticos con retención de 30 días. | Confiabilidad | Media |
| **RNF08** | Rendimiento iOS | Las pantallas críticas deben cargar en < 300 ms (P95). | Performance | Alta |
| **RNF09** | Latencia del Backend | Respuestas de microservicios < 200 ms en endpoints principales. | Performance | Alta |
| **RNF10** | Cache Local en iOS | Barberías y servicios deben poder leerse offline. | Usabilidad | Media |
| **RNF11** | Consistencia Eventual | Notificaciones, chat y disponibilidad se actualizan por Realtime. | Arquitectura | Media |
| **RNF12** | UX/Accesibilidad | Cumplir estándares iOS UIKit & SwiftUI Accessibility. | Usabilidad | Media |
| **RNF13** | Mantenibilidad | Código modular en capas MVVM + Repositorios + Servicios. | Código | Alta |
| **RNF14** | Observabilidad | Logs estructurados + métricas + trazas distribuidas (OpenTelemetry). | Operación | Media |
| **RNF15** | Portabilidad | Microservicios deben funcionar en Docker sin dependencias externas. | Arquitectura | Alta |
| **RNF16** | Escalado de Chat | Websockets deben soportar al menos 1k conexiones concurrentes. | Performance | Media |
| **RNF17** | Privacidad | Cumplir legislación local de protección de datos. | Legal | Alta |
| **RNF18** | Tolerancia a Errores | Retries automáticos en fallas temporales de red. | Confiabilidad | Media |

---

## CASOS DE USO

### CS01: Iniciar Sesión

**Actores:** Usuario

**Objetivo:** Permitir que los usuarios accedan al sistema utilizando sus credenciales.

**Precondiciones:** El usuario debe estar registrado en el sistema.

**Secuencia Normal:**
1. El usuario accede a la vista de inicio de sesión de la app.
2. El usuario ingresa su nombre de usuario y contraseña.
3. El sistema verifica las credenciales del usuario.
4. Si las credenciales son válidas, el sistema permite al usuario acceder al sistema.

**Escenario Alternativo:** Si las credenciales son inválidas, el sistema muestra un mensaje de error y vuelve al paso 2.

**Postcondiciones:** El usuario ha iniciado sesión en la app y puede acceder a las funciones correspondientes a su rol (cliente, barbero o administrador).

---

### CS02: Registrar o Crear Usuario

**Actores:** Usuario

**Objetivo:** Permitir al Usuario registrarse en la App.

**Precondiciones:** El usuario no debe tener el correo registrado en sistema.

**Secuencia Normal:**
1. El usuario ingresa a la app y presiona la opción de Sign Up.
2. El Usuario ingresa sus datos como nombre completo, email, contraseña.
3. Presiona el botón SignUp para enviar los datos del formulario.
4. El sistema de app lo envía a la vista Home para comenzar a navegar dentro de la app y explorar las funciones.

**Escenario Alternativo:** Si los datos ingresados por el Usuario no son válidos (por ejemplo, el correo electrónico ya está registrado), el sistema muestra un mensaje de error y vuelve al paso 2.

**Postcondiciones:** El nuevo usuario ha sido registrado en el sistema y puede iniciar sesión con sus credenciales.

---

### CS03: Cerrar Sesión

**Actores:** Usuario

**Objetivo:** Permitir que los usuarios cierren sesión en el sistema.

**Precondiciones:** El usuario debe haber iniciado sesión o estar activo en la App.

**Secuencia Normal:**
1. El usuario debe ingresar a la sección de perfil e ir a la opción "Cerrar Sesión" en la interfaz de la App.
2. El sistema cierra la sesión del usuario.
3. El sistema redirige al usuario a la página de inicio de sesión.

**Postcondiciones:** El usuario ha cerrado sesión en el sistema y se encuentra en la vista inicio de sesión.

---

### CS04: Listar Barberías

**Actores:** Usuario

**Objetivo:** El sistema permite que el Usuario visualice la lista de todas las barberías disponibles en el sistema.

**Precondiciones:** El Usuario debe estar activo en la app o haber iniciado sesión.

**Secuencia Normal:**
1. El Usuario ingresa a la opción que le permite ver la lista de las barberías.
2. El sistema carga la lista de todas las barberías que se encuentran registradas en el sistema, mostrando su estado.
3. El usuario puede seleccionar cualquier barbería para ver la información más detallada.

**Postcondiciones:** El Usuario visualiza la lista de barberías disponibles.

---

### CS05: Seleccionar Barbería

**Actores:** Usuario

**Objetivo:** El sistema permite al Usuario seleccionar la barbería de su preferencia de las cuales están disponibles en el sistema.

**Precondiciones:** El Usuario debe estar activo en la app o haber iniciado sesión.

**Secuencia Normal:**
1. El Usuario debe ingresar la opción de las barberías para obtener la lista de las barberías disponibles.
2. El Usuario puede seleccionar la barbería de su preferencia.
3. Una vez seleccionada la barbería, el sistema de la app mostrará información detallada de la barbería como: ubicación, teléfono, horarios de apertura y cierre, servicios que están disponibles.

**Escenario Alternativo:**
1. Si la barbería seleccionada no está disponible temporalmente (por ejemplo, cerrada por el día).
2. El sistema muestra un mensaje indicando que la barbería no está disponible en este momento y sugiere al Usuario seleccionar otra.

**Postcondiciones:** El Usuario ha seleccionado una barbería y puede proceder a realizar acciones adicionales, como programar una cita en esa barbería.

---

### CS06: Seleccionar Barbero

**Actores:** Usuario

**Objetivo:** El sistema le permite seleccionar un barbero específico para generar la reserva.

**Precondiciones:** El Usuario debe estar activo en la app o haber iniciado sesión. Ingresar en la sección de barbero.

**Secuencia Normal:**
1. El Usuario ingresa a la sección de barberos.
2. El sistema de la app muestra la lista de los barberos disponibles.
3. El Usuario selecciona el barbero de su preferencia.
4. La app carga toda la información del barbero seleccionado donde le permite visualizar horarios disponibles.
5. El sistema le permite realizar la reserva con el barbero seleccionado.

**Escenario Alternativo:**
1. Si el barbero seleccionado no está disponible en el momento seleccionado por el cliente, el sistema muestra un mensaje indicando que el barbero seleccionado no está disponible y sugiere al cliente seleccionar otro barbero disponible.

**Postcondiciones:** El Usuario ha seleccionado un barbero específico para su cita en la barbería seleccionada.

---

### CS07: Agendar Cita

**Actores:** Usuario

**Objetivo:** El sistema permite realizar un agendamiento o reservar en la barbería con el barbero seleccionado en los horarios disponibles.

**Precondiciones:** El Usuario debe estar activo en la app o haber iniciado sesión. Haber seleccionado la barbería y realizar la acción de agendar cita o generar reserva.

**Secuencia Normal:**
1. El Usuario ingresa a la barbería.
2. Presiona el botón de agendar.
3. La app carga la información de disponibilidad con fecha y horario.
4. El Usuario selecciona la fecha y hora de su preferencia o que se encuentre disponible y se cargan los datos del usuario para continuar la reserva.
5. La app mostrará un mensaje de confirmación indicando que la reserva fue exitosa y regresando a la vista home.

**Escenario Alternativo:**
1. Si la fecha y hora seleccionadas no están disponibles (porque ya están reservadas o porque la barbería no ofrece servicio en ese momento).
2. El sistema de la app muestra un mensaje indicando que la fecha y hora seleccionadas no están disponibles y sugiere al Usuario seleccionar otra fecha y hora.

**Postcondiciones:** El cliente ha agendado una cita en la barbería seleccionada.

---

### CS09: Servicios de Barbería

**Actores:** Usuario

**Objetivo:** El sistema le permite visualizar la lista de los servicios ofrecidos por una barbería seleccionada.

**Precondiciones:** El Usuario debe tener la sesión iniciada.

**Secuencia Normal:**
1. El Usuario ingresa a la opción de Servicios de la Barbería Seleccionada.
2. El sistema carga los servicios que ofrece la barbería de forma detallada con precios y tiempos aproximados.

**Escenario Alternativo:** Si no hay servicios disponibles en la barbería seleccionada en ese momento, el sistema muestra un mensaje indicando que no hay servicios disponibles en este momento y sugiere al cliente intentarlo más tarde.

**Postcondiciones:** El Usuario ha visto la lista de servicios ofrecidos por la barbería seleccionada.

---

### CS10: Perfil de Usuario

**Actores:** Usuario

**Objetivo:** El sistema le carga toda la información registrada del Usuario y le permite realizar cambios o modificaciones de su perfil.

**Precondiciones:** El cliente ha iniciado sesión en el sistema.

**Secuencia Normal:**
1. El Usuario ingresa a la opción de Perfil.
2. El Sistema carga toda la información del Usuario que registró previamente.
3. El sistema le permite agregar más datos; este campo es opcional para el Usuario.
4. Para guardar los cambios en perfil debe presionar el botón de guardar cambios.

**Escenario Alternativo:**
1. El sistema mostrará un mensaje indicando que los cambios realizados no se guardaron de forma correcta ya que no tiene conexión con el servidor.
2. Si el usuario realiza una modificación y desea regresar sin guardar los cambios, el sistema mostrará un mensaje indicando que quiere deshacer los cambios hechos.
3. Si confirma deshacer los cambios, el sistema le permite regresar o cambiar de opción desde la barra de navegación.
4. Si cancela la notificación, el sistema permanece en la misma vista hasta realizar alguna acción de cambio de vista.

**Postcondiciones:** El cliente ha visto su propio perfil de usuario en el sistema.

---

### CS11: Acceder Ayuda y Soporte

**Actores:** Usuario

**Objetivo:** Permitir que el cliente acceda a recursos de ayuda y soporte.

**Precondiciones:** El Usuario ha iniciado sesión en el sistema.

**Secuencia Normal:**
1. El cliente accede a la sección de ayuda y soporte, generalmente a través de un enlace o botón en su perfil o en el menú de navegación.
2. El sistema muestra una variedad de recursos de ayuda y soporte, que pueden incluir preguntas frecuentes (FAQ), guías de uso, tutoriales, información de contacto para soporte técnico, etc.

**Escenario Alternativo:** Si no hay recursos de ayuda y soporte disponibles en ese momento, el sistema muestra un mensaje indicando que la sección de ayuda y soporte no está disponible temporalmente y sugiere al cliente intentarlo más tarde.

**Postcondiciones:** El cliente ha accedido a la sección de ayuda y soporte en el sistema.

---

### CS12: Cambio de Password

**Actores:** Usuario

**Objetivo:** El sistema permite que el Usuario modifique sus credenciales de inicio de sesión en el sistema.

**Precondiciones:** El cliente ha iniciado sesión en el sistema.

**Secuencia Normal:**
1. El Usuario accede a su perfil.
2. El sistema muestra las opciones de modificación de credenciales, como cambiar la dirección de correo electrónico o la contraseña.
3. El cliente selecciona la opción para modificar las credenciales.
4. El cliente ingresa la nueva información de inicio de sesión, que puede incluir una nueva dirección de correo electrónico, contraseña o ambos.
5. El sistema verifica la validez de la nueva información ingresada por el cliente.
6. Si la información es válida, el sistema actualiza las credenciales del cliente y muestra un mensaje de confirmación.

**Escenario Alternativo:** Si la nueva información de inicio de sesión ingresada por el cliente no es válida (por ejemplo, contraseña demasiado corta), el sistema muestra un mensaje indicando que la información es inválida y solicita al cliente corregirla.

**Postcondiciones:** Las credenciales de inicio de sesión del cliente han sido modificadas con éxito en el sistema.

---

### CU: Reseñas

**Actores:** Usuario

**Objetivo:** El sistema muestra los comentarios en la opción de reseña de la barbería mostrando comentarios y reputación del lugar.

**Precondiciones:** El Usuario debe tener la sesión activa, tener seleccionada una barbería de la lista para ver la reseña.

**Secuencia Normal:**
1. El Usuario selecciona la barbería de su preferencia.
2. Ingresa a la opción de ver reseña y comentarios.
3. El sistema de la app carga todos los comentarios y reputación que tiene la barbería. También muestra la calificación en reputación que tiene la barbería.

**Escenario Alternativo:** Si no hay reseñas disponibles para la barbería seleccionada en ese momento, el sistema muestra un mensaje indicando que no hay reseñas disponibles en este momento y sugiere al Usuario realizar la primera reseña o intentarlo más tarde.

**Postcondiciones:** El Usuario ha visto las reseñas y opiniones de otros clientes sobre la barbería seleccionada.

---

### CU: Historial de Reservas

**Actores:** Usuario

**Objetivo:** El sistema le permite visualizar el historial de reservas hechas, mostrando los estados de Cancelado, finalizadas en el sistema.

**Precondiciones:** El Usuario debe tener la sesión activa.

**Secuencia Normal:**
1. El cliente accede a la sección de citas, que puede estar disponible en su perfil o en el menú principal.
2. El sistema muestra una lista de las citas del cliente, organizadas en tres secciones: citas programadas, citas pendientes y citas finalizadas.
3. El cliente puede navegar entre las secciones para ver las citas programadas, pendientes y finalizadas por separado.

**Escenario Alternativo:** Si no hay citas programadas, pendientes o finalizadas para el cliente en ese momento, el sistema muestra un mensaje indicando que no hay citas disponibles en este momento y sugiere al cliente intentarlo más tarde.

**Postcondiciones:** El cliente ha visto la lista de sus citas programadas, pendientes y finalizadas en el sistema.

---

### CU: Detalles de la Reserva

**Actores:** Usuario

**Objetivo:** Permitir que el cliente vea los detalles específicos de una cita en el sistema.

**Precondiciones:** El cliente ha iniciado sesión en el sistema y tiene al menos una cita programada, pendiente o finalizada.

**Secuencia Normal:**
1. El cliente accede a la sección de citas, donde puede ver la lista de sus citas.
2. El cliente selecciona una cita específica de la lista para ver más detalles.
3. El sistema muestra los detalles específicos de la cita seleccionada, que pueden incluir la fecha y hora de la cita, el barbero asignado, los servicios solicitados, el estado de la cita (programada, pendiente, finalizada), la ubicación de la barbería, etc.

**Escenario Alternativo:** Si no se pueden mostrar los detalles de la cita en ese momento (por ejemplo, si hay un error en el sistema), el sistema muestra un mensaje indicando que no se pueden mostrar los detalles en este momento y sugiere al cliente intentarlo más tarde.

**Postcondiciones:** El cliente ha visto los detalles específicos de la cita seleccionada en el sistema.

---

### CU: Estado de la Reserva (Barbero)

**Actores:** Barbero

**Objetivo:** Permitir que el barbero visualice una lista de las citas pendientes o finalizadas que tiene en su agenda.

**Precondiciones:** El barbero ha iniciado sesión en el sistema y tiene citas programadas.

**Secuencia Normal:**
1. El barbero accede a la sección de citas en su panel de control.
2. El barbero selecciona la opción para listar las citas pendientes o finalizadas.
3. El sistema muestra una lista de citas pendientes o finalizadas del barbero, según la opción seleccionada.

**Escenario Alternativo:** Si no hay citas pendientes o finalizadas para el barbero en ese momento, el sistema muestra un mensaje indicando que no hay citas disponibles y sugiere al barbero revisar más tarde.

**Postcondiciones:** El barbero ha visualizado la lista de citas pendientes o finalizadas en su agenda.

---

## ESTRUCTURA DEL PROYECTO iOS

```
├── AdminFeatures
│   └── Schedule
│       ├── Models (AvailabilitySummary, BarberSchedule, BreakTime, etc.)
│       ├── Services (ScheduleService + Extensions)
│       ├── ViewModels (ScheduleViewModel)
│       └── Views (Calendar, Availability, Components)
│
├── Core
│   ├── Models
│   │   ├── Booking (Appointment extensions, filters, reminders)
│   │   ├── Business (BarberWithRating)
│   │   └── User (UserRole)
│   ├── Services
│   │   ├── Authentication (AuthenticationService)
│   │   ├── Booking (AppointmentService + Extensions)
│   │   ├── Business (BarberService, BranchService, ServiceService)
│   │   ├── Marketing (FavoriteService, PromotionService, ReviewsService)
│   │   ├── Network/SupaBase (ConfigManager, SupabaseManager)
│   │   └── Notification (NotificationService + Extension)
│   ├── Utilities (LocationManager, Extensions)
│   └── ViewModels (BaseViewModel)
│
├── Features
│   ├── Appointments (ViewModels, Views)
│   ├── Authentication (Models, ViewModels, Views)
│   ├── Barbers (Models, Views, Components)
│   ├── Booking (Complete booking flow)
│   ├── Branches (Models, ViewModels, Views)
│   ├── Explore (ExploreView)
│   ├── Home (ViewModels, Views, Components)
│   ├── Main (MainTabView)
│   ├── Maps (MapViewModel, MapView)
│   ├── Notifications (Models, Views)
│   ├── Onboarding (Models, Views, Helpers)
│   ├── Profile (ViewModels, Views)
│   ├── Promotions (Models, Views)
│   └── Services (Models, Views, Components)
│
└── SharedComponents
    ├── Cards (BarberCard, PromotionCard, ServiceCard)
    ├── Map (BranchMapMarker)
    └── Placeholders (Loading states)
```

---

## ANÁLISIS DE FUNCIONALIDADES PENDIENTES

### 1. Sistema de Reviews Completo
- [ ] Vista para escribir reseñas
- [ ] Sistema de calificación por estrellas mejorado
- [ ] Moderación de comentarios
- [ ] Reportar reseñas inapropiadas
- [ ] Filtros y ordenamiento avanzado

### 2. Gestión de Horarios Avanzada
- [x] Calendario de disponibilidad de barberos ✅
- [x] Bloques de tiempo personalizables ✅
- [x] Sincronización en tiempo real ✅
- [ ] Gestión de vacaciones
- [ ] Horarios especiales por fechas

### 3. Sistema de Cancelación Mejorado
- [x] Cancelar citas programadas ✅
- [ ] Políticas de cancelación configurables
- [ ] Penalizaciones por cancelaciones frecuentes
- [ ] Notificaciones de cancelación

### 4. Multi-idioma (i18n)
- [ ] Español
- [ ] Inglés
- [ ] Sistema de localización completo

### 5. Modo Offline
- [ ] Caché de datos esenciales
- [ ] Cola de sincronización
- [ ] Indicadores de estado de red

### 6. Sistema de Preferencias
- [ ] Barbero favorito
- [ ] Servicios frecuentes
- [ ] Horarios preferidos
- [ ] Recordatorios personalizados

### 7. Onboarding Mejorado
- [x] Tutorial básico ✅
- [ ] Tutorial interactivo avanzado
- [ ] Personalización inicial
- [ ] Permisos explicados con contexto

### 8. Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] UI tests
- [ ] Variantes de UI
- [ ] Análisis de conversión

### 9. Geolocalización Avanzada
- [x] Búsqueda por cercanía ✅
- [ ] Estimación de tiempo de llegada
- [ ] Rutas optimizadas

### 10. Analíticas y Reportes
- [ ] Dashboard de administrador
- [ ] Volumen de citas programadas
- [ ] Citas activas y canceladas
- [ ] Reportes por día/mes
- [ ] Métricas de ocupación

### 11. Protección de Datos
- [x] Comunicación HTTPS ✅
- [x] Políticas de privacidad ✅
- [ ] Encriptación end-to-end
- [ ] Auditoría de accesos

### 12. In-App Feedback
- [ ] Sistema de reporte de bugs
- [ ] Encuestas de satisfacción
- [ ] Rating de la app

### 13. Funcionalidades Sociales
- [ ] Código de referido único
- [ ] Recompensas por referidos
- [ ] Invitaciones

### 14. Panel Web para Administrador
- [ ] CRUD de servicios
- [ ] CRUD de productos
- [ ] CRUD de empleados
- [ ] Dashboard de estado de cuentas
- [ ] Usuarios activos
- [ ] CRUD de Barberías
- [ ] Sistema de autenticación

### 15. Herramientas de Administración
- [ ] Dashboard de métricas para barbería
- [x] Gestión de barberos ✅
- [x] Configuración de horarios ✅
- [ ] Análisis de ingresos
- [ ] Gestión de inventario

---

## NOTAS IMPORTANTES

### Modelo de Negocio
**Los pagos se realizan directamente en la barbería.** La aplicación no procesa pagos electrónicos. El flujo es:
1. Cliente agenda cita en la app
2. Cliente asiste a la barbería
3. Cliente recibe el servicio
4. Cliente paga en efectivo o tarjeta directamente en la barbería

### Prioridades de Desarrollo
1. **Crítico:** RF10 (Agendar Cita), RNF04 (Prevención doble reserva)
2. **Alto:** Autenticación, Gestión de barberos y servicios, Notificaciones
3. **Medio:** Reseñas, Chat, Multi-idioma
4. **Bajo:** Calendario iOS, Funcionalidades sociales

### Tecnologías Utilizadas
- **Frontend:** SwiftUI (iOS)
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Realtime)
- **Arquitectura:** MVVM
- **Autenticación:** Supabase Auth (JWT)
- **Base de Datos:** PostgreSQL con Row Level Security

---

**Documento actualizado:** 08/02/2026  
**Próxima revisión:** 22/02/2026