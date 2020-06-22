#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "menu.h"

#define DIM 100
#define FIL 30
#define COL 30

#define AR_CLIENTE "clientes.dat"
#define AR_CLI_ALTA "clientesalta.dat"
#define AR_CLI_BAJA "clientesbaja.dat"
#define AR_CONSUMOS "consumos.dat"

typedef struct{
   int  id; /// campo único y autoincremental
   int nroCliente;
   char nombre[30];
   char apellido[30];
   int dni;
   char email[30];
   char domicilio[45];
   char movil[15];
   int baja; /// 0 si está activo - 1 si está eliminado
}stCliente;
typedef struct{
    int id; /// campo único y autoincremental
    int idCliente;
    int anio;
    int mes; /// 1 a 12
    int dia; /// 1 a … dependiendo del mes
    int datosConsumidos; /// expresados en mb.
    int baja; /// 0 si está activo - 1 si está eliminado
}stConsumos;

///FUNCIONES CLIENTES
int validaEmail(char email[]);
stCliente cargaUnCliente();
int buscaUltimoIdCliente();
void cargaArchivoClientes(char nombreArchivo[]);
void guardaUnCliente(stCliente c, char nombreArchivo[]);
int existeCliente(int cliente);
void muestraUnCliente(stCliente c);
void muestraArch(char nombreArchivo[]);
void creaArchivo(char nombreArchivo[], int bajaOalta);
void modificaRegistro(stCliente c, int idCliente);
void bajaCliente(int idCliente);
int arch2array(int dni[]);
void ordPorInserArray(int a[], int dim);
int arch2arrayChar(int fil, int col, char apellidos[fil][col]);
void ordenacionString(int fil, int col, char as[fil][col], int validos);;
void muestraClienteXid(int id, char nombreArchivo[]);
int arch2arrayMailsChar(int fil, int col, char email[fil][col]);
void muestraArregloString(int fil, int col, char as[][col], int v);
void muestraArrayInt(int a[], int v);
///FUNCIONES CONSUMOS
void muestraUnConsumo(stConsumos c);
void muestraArchConsumos(char nombreArchivo[]);
stConsumos cargaUnConsumo(int dia, int mes, int anio);
int ultimoConsumoDia(int mes, int dia, int idCliente);
void guardaUnConsumo(stConsumos c);
int buscaUltimoIdConsumo();
int buscaPosConsumo(int id);
void bajaConsumo(int dia, int mes, int anio);
int buscaIdXFechaConsumo(int dia, int mes, int anio);
void modificaRegistroConsumos(stConsumos c, int idConsumo);
stConsumos cargaUnConsumoUser();

///FUNCION QUE IMPRIME UNA CABECERA, EN LOS PARAMETROS ESCRIBIMOS EL TEXTO.
void imprimirCabecera(char cabecera[])
{
    int i;
    ///ESQUINA IZQUIERDA ARRIBA.
    printf("\t\t\t\t %c", 201);
    for(i=0; i<50; i++)
    {
    ///PARTE DE ARRIBA.
        printf("%c",205);
    }
    ///ESQUINA DERECHA ARRIBA
    printf("%c\n", 187);
    ///LATERAL DERECHO.
    printf("\t\t\t\t %c%32s%19c\n", 186,cabecera,186);
    ///ESQUINA IZQUIERDA ABAJO.
    printf("\t\t\t\t %c", 200);
    for(i=0; i<50; i++)
    {
    ///PARTE DE ABAJO.
        printf("%c",205);
    }
    ///ESQUINA DERECHA ABAJO.
    printf("%c", 188);
}

void imprimirTutorial(char cabecera[])
{
    int i;
    printf("%c", 201);
    for(i=0; i<113; i++)
    {
        printf("%c",205);
    }
    printf("%c\n", 187);
    printf("%c%32s\t\t\t\n", 186,cabecera);
    printf("%c", 200);
    for(i=0; i<113; i++)
    {
        printf("%c",205);
    }
    printf("%c", 188);
}

void imprimirFunciones(char cabecera[])
{
    int i;
    int y;
                                                    ///ESQUINA IZQUIERDA ARRIBA.
    printf("%c", 201);
    for(i=0; i<70; i++)
    {
                                                    ///PARTE DE ARRIBA.
        printf("%c",205);
    }
                                                    ///ESQUINA DERECHA ARRIBA
    printf("%c\n", 187);

                                                    ///LATERAL DERECHO.
    printf("%c %s", 186,cabecera);
    printf("\n");
    for(y=0; y<10; y++)
    {
                                                    ///LATERAL DERECHO.
    printf("%c\n",186);
    }
                                                    ///ESQUINA IZQUIERDA ABAJO.
    printf("%c", 200);
    for(i=0; i<70; i++)
    {
                                                    ///PARTE DE ABAJO.
        printf("%c",205);
    }
                                                    ///ESQUINA DERECHA ABAJO.
    printf("%c", 188);
}



void imprimirOpcionesMenu()      ///FUNCION QUE IMPRIME LAS OPCIONES DEL MENU PRINCIPAL, depende de la funcion ingresarOpcion.
{
    system("color 2A");
    printf("\nTUTORIAL...\n");
    imprimirTutorial("En las diferentes opcion te dan acceso a un SUBMENU determinado.");
    printf("\n\n1. MENU DE CLIENTES.\n");
    printf("\n\n2. MENU DE CONSUMOS.\n");
    printf("\n\n0. Salir de la aplicacion.\n ");
}

void imprimirOpcionesMenuClientes()  ///FUNCION QUE IMPRIME EL MENU DEL CLIENTE, depende de la funcion ingresarOpcion.
{
    system("color 2A");
    printf("\nTUTORIAL...\n");
    imprimirTutorial("Cada opcion tiene su uso especifico, en este SUBMENU SOLAMENTE es para los CLIENTES.");
    printf("\n\n1. CARGA CLIENTES.\n");
    printf("\n\n2. MODIFICA CLIENTES.\n");
    printf("\n\n3. MUESTRA CLIENTE.\n");
    printf("\n\n4. DAR DE BAJA UN CLIENTE.\n");
    printf("\n\n5. VOLVER AL MENU PRINCIPAL.\n");
    printf("\n\n0. Salir\n");
}

void imprimirOpcionesMenuConsumos()  /// FUNCION QUE IMPRIME EL MENU DE CONSUMOS, depende de la funcion ingresarOpcion.
{
    system("color 2A");
    printf("\nTUTORIAL...\n");
    imprimirTutorial("Cada opcion tiene su uso especifico, en este SUBMENU SOLAMENTE es para los CLIENTES.");
    printf("\n\n1. LISTA DE CONSUMO TOTAL.\n");
    printf("\n\n2. BUSCAR CONSUMO ESPECIFICO.\n");
    printf("\n\n3. Volver al menu principal.\n");
    printf("\n\n0. Salir\n");
}

int ingresarOpcion()   /// LLamamos a esta funcion cuando necesitamos una carga de opciones.
{
    int opcion;
    printf("\n\n\n\n\n\t Ingrese opcion: ");
    fflush(stdin);
    scanf("%i", &opcion);
    return opcion;
}

void switchSubMenuClientes()     /// SUB MENU DE CLIENTES, DONDE LLAMAMOS A LAS FUNCIONES DE CLIENTES.
{
    int opClientes;
    stCliente cliente;
    int idCliente=-1;
    int dni[10];
    int validos=0;
    int validosChar=0;
    char apellidos[FIL][COL];
    char email[FIL][COL];
    int vMails = 0;
    do
    {
        opClientes = ingresarOpcion();
        switch(opClientes)
        {
        case 1: ///Dependiendo de lo que se necesite en cada case se puede llamar a un submenu o a una funcion en especifico
            system("cls");
            printf("\nTUTORIA...\n");
            imprimirTutorial("¡ATENCION! AL CREAR UN CLIENTE NUEVO , A TAL CLIENTE SE LE ASIGNA UN ID...");
            printf("\n");
            imprimirCabecera("TIPS");
            printf("\n");
            imprimirTutorial("Con el ID , tenemos la posibilidad de modificar un cliente, otorgandote una mayor accesibilidad a los datos.");
            printf("\n");
            system("pause");
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            cargaArchivoClientes(AR_CLIENTE);
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            system("cls");
            imprimirCabecera("CLIENTES.");
            imprimirOpcionesMenuClientes();
            ///APRENDER A USAR GOTOXY PARA QUE EL PUNTERO APAREZCA EN EL TOPE DE LA LISTA, QUEDA MAS BONITO QUE EMPIECE DE ARRIBA PARA ABAJO.
            break;
        case 2:
            system("cls");
            printf("\nTUTORIA...\n");
            imprimirTutorial("ESTA FUNCION NOS PERMITE RE CONFIGURAR UN CLIENTE.");
            printf("\n");
            imprimirTutorial("¡ATENCION! ES MUY IMPORTANTE NO EQUIVOCARSE EN EL NUMERO DE CLIENTE.");
            printf("\n");
            imprimirTutorial("¡ATENCION! LA INFORMACION PREVIA A LA MODIFICACION SERA ELIMINADA.");
            printf("\n");
            system("pause");
            system("cls");
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            printf("\nINGRESAR ID:\n");
            scanf("%d", &idCliente);
            printf("\nCARGAR NUEVOS DATOS:\n");
            cliente = cargaUnCliente();
            modificaRegistro(cliente, buscaPos(idCliente, AR_CLIENTE));
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            system("cls");
            imprimirCabecera("CLIENTES.");
            imprimirOpcionesMenuClientes();
            break;
        case 3:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("ENLACE DE SOLO LECTURA, PRESIONAR LA LETRA [ESC] PARA SALIR.");
            printf("\n");
            imprimirCabecera("LISTA DE CLIENTES ORDENADOS POR DNI EN ALTA:");
            printf("\n");
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            validos = arch2array(dni);
            ordPorInserArray(dni, validos);
            muestraArrayInt(dni, validos);
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            printf("\n\n\n\n");
            system("pause");
            system("cls");
            imprimirCabecera("Clientes.");
            imprimirOpcionesMenuClientes();
            break;
        case 4:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("ENLACE DE SOLO LECTURA, PRESIONAR LA LETRA [ESC] PARA SALIR.");
            printf("\n");
            imprimirCabecera("LISTA DE CLIENTES ORDENADOS POR APELLIDOS EN ALTA:");
            printf("\n");
            validosChar = arch2arrayChar(FIL, COL, apellidos);
            ordenacionString(FIL, COL, apellidos, validosChar);
            muestraArregloString(FIL, COL, apellidos, validosChar);
            printf("\n\n\n\n");
            system("pause");
            system("cls");
            imprimirCabecera("Clientes.");
            imprimirOpcionesMenuClientes();
        case 5:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("ENLACE DE SOLO LECTURA, PRESIONAR LA LETRA [ESC] PARA SALIR.");
            printf("\n");
            imprimirCabecera("BUSQUEDA POR ID.");
            printf("\n");
            printf("\nINGRESAR ID:  ");
            scanf("%d", &idCliente);
            muestraClienteXid(idCliente, AR_CLI_ALTA);
            printf("\n\n\n\n");
            system("pause");
            system("cls");
            imprimirCabecera("Clientes.");
            imprimirOpcionesMenuClientes();
        case 6:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("ENLACE DE SOLO LECTURA, PRESIONAR LA LETRA [ESC] PARA SALIR.");
            printf("\n");
            imprimirCabecera("MUESTRA CLIENTE EN BAJA ORDENADOS POR MAIL:");
            printf("\n");
            vMails = arch2arrayMailsChar(FIL, COL, email);
            ordenacionString(FIL, COL, email, vMails);
            muestraArregloString(FIL, COL, email, vMails);
            printf("\n\n\n\n");
            system("pause");
            system("cls");
            imprimirCabecera("Clientes.");
            imprimirOpcionesMenuClientes();
        case 7:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("ESTA FUNCION NOS PERMITE DAR DE BAJA A UN CLIENTE.");
            printf("\n");
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            printf("\n ID DEL USUARIO: ");
            scanf("%d", &idCliente);
            bajaCliente(idCliente);
            /////////////////////////////////////VARIABLES////////////////////////////////////////////
            printf("\n");
            system("pause");
            system("cls");
            imprimirCabecera("CLIENTES.");
            imprimirOpcionesMenuClientes();
        case 8:
            system("cls");
            iniciarMenu();
            system("pause");
            break;
        default:
            printf("Opcion incorrecta\n");
        }
    }
    while(opClientes != 0);
}

void switchSubMenuConsumos()  /// SUB MENU DE CONSUMOS, DONDE LLAMAMOS A LAS FUNCIONES DE CONSUMIDORES.
{
    int opConsumos;
    stConsumos consumo;
    int idConsumo;
    int dia=0;
    int mes=0;
    int anio=0;
    do
    {
        opConsumos = ingresarOpcion();
        switch(opConsumos)
        {
        case 1: ///Dependiendo de lo que se necesite en cada case se puede llamar a un submenu o a una funcion en especifico
            system("cls");
            printf("\nTUTORIA...\n");
            imprimirTutorial("ESTA FUNCION NOS PERMITE CARGAR UN CONSUMO INDIVIDUAL.");
            printf("\n");
            cargaArchivoConsumos();
            system("cls");
            imprimirCabecera("CONSUMOS");
            imprimirOpcionesMenuConsumos();
            break;
        case 2:
            system("cls");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("LISTA DE CONSUMOS, NO PUEDE SER MODIFICADA YA QUE ES DE SOLO LECTURA.");
            printf("\n");
            muestraArchConsumos(AR_CONSUMOS);
            system("pause");
            system("cls");
            imprimirCabecera("Consumos.");
            imprimirOpcionesMenuConsumos();
            break;

        case 3:
            system("cls");
            imprimirCabecera("BAJA Y ALTA DE CONSUMOS EN LA FECHA DE : ..../..../....");
            printf("\nTUTORIAL...\n");
            imprimirTutorial("CARGAR LOS DATOS [ DIA/MES/ANIO ] EN LOS CAMPOS CORRESPONDIENTES.");
            printf("\n");
            imprimirTutorial("SI EL CONSUMO FUE DADO DE BAJA PREVIAMENTE, ESTE VOLVERA A ESTAR EN ALTA.");
            printf("\nDIA: ");
            scanf("%d", &dia);
            printf("\nMES: ");
            scanf("%d", &mes);
            printf("\nANIO: ");
            scanf("%d", &anio);
            bajaConsumo(dia, mes, anio);
            system("pause");
            system("cls");
            imprimirCabecera("Consumos.");
            imprimirOpcionesMenuConsumos();
        case 4:
            system("cls");
            printf("\nTUTORIA...\n");
            imprimirTutorial("ESTA FUNCION NOS PERMITE RE CONFIGURAR UN CONSUMO.");
            printf("\n");
            imprimirTutorial("¡ATENCION! ES MUY IMPORTANTE NO EQUIVOCARSE EN EL NUMERO DE ID.");
            printf("\n");
            imprimirTutorial("¡ATENCION! LA INFORMACION PREVIA A LA MODIFICACION SERA ELIMINADA.");
            printf("\n");
            system("pause");
            system("cls");
            printf("\n");
            printf("\nIngrese el ID del consumo a modificar: ");
            scanf("%d", &idConsumo);
            consumo = cargaUnConsumoUser();
            modificaRegistroConsumos(consumo, idConsumo);
            system("pause");
            system("cls");
            imprimirCabecera("Consumos.");
            imprimirOpcionesMenuConsumos();
        case 5:
            system("cls");
            iniciarMenu();
            system("pause");
            break;
        default:
            printf("Opcion incorrecta\n");
        }
    }
    while(opConsumos != 0);
}

int switchMenu()   /// MENU PRINCIPAL, ELEGIMOS LA OPCION 1, BORRA EL BUFFER IMPRIME CABECERA DE CLIENTES           -
{
    /// IMPRIME LAS OPCIONES DE CONSUMO Y CAMBIA AL SUBMENU CLIENTES DONDE SE ENCUENTRAN LAS FUNCIONES.
    int op;
    do
    {
        op = ingresarOpcion();
        switch(op)
        {
        case 0:
            system("cls");
            printf("Saliendo del sistema\n");
            system("pause");
            break;
        case 1:
            system("cls");
            imprimirCabecera("SUBMENU: Clientes");
            printf("\n\n");
            imprimirOpcionesMenuClientes();
            switchSubMenuClientes();
            break;
        case 2:
            system("cls");
            imprimirCabecera("SUBMENU: Consumos");
            printf("\n\n");
            imprimirOpcionesMenuConsumos();
            switchSubMenuConsumos();
            break;
        case 3:
            system("cls");
            creaArchivo(AR_CLI_ALTA, 0);
            creaArchivo(AR_CLI_BAJA, 1);
        default:
            printf("Opcion incorrecta\n");
            break;
        }
    }
    while(op != 0);
    return op;
}


void iniciarMenu()    /// SEMILLA DEL MENU PRINCIPAL, MODIFICANDO ESTA FUNCION PODEMOS VARIAR EL DISEÑO.
{
    int salida;
    do
    {
        system("cls");
        imprimirCabecera("CLIENTES Y CONSUMOS.");
        printf("\n\n");
        imprimirOpcionesMenu();
        salida = switchMenu();
    }
    while(salida != 0);
}




stConsumos cargaUnConsumoUser()
{
    stConsumos c;

    printf("\nIngrese el nuevo ID: ");
    scanf("%d", &c.id);
    printf("\nIngrese el nuevo  ID del cliente: ");
    scanf("%d", &c.idCliente);
    printf("\nIngrese el nuevo anio: ");
    scanf("%d", &c.anio);
    printf("\nIngrese el nuevo mes: ");
    scanf("%d", &c.mes);
    printf("\nIngrese el nuevo dia: ");
    scanf("%d", &c.dia);
    printf("\nIngrese los nuevos datos consumidos: ");
    scanf("%d", &c.datosConsumidos);
    printf("\nIngrese 1 si decide darlo de baja, sino 0: ");
    scanf("%d", &c.baja);

    return c;
}
void modificaRegistroConsumos(stConsumos c, int idConsumo)/// En c están los datos nuevos que se quieren guardar
{                                                        /// e idConsumo el id del cliente cuyos datos se quieren pisar
    FILE *pArchConsumo = fopen(AR_CONSUMOS, "r+b");

    if(pArchConsumo)
    {
        fseek(pArchConsumo, sizeof(stConsumos)*idConsumo, SEEK_SET);
        fwrite(&c, sizeof(stConsumos), 1, pArchConsumo);
        fclose(pArchConsumo);
    }
}
int buscaIdXFechaConsumo(int dia, int mes, int anio)
{
    int id = -1;

    stConsumos c;

    FILE *pArchConsumos = fopen(AR_CONSUMOS, "rb");

    if(pArchConsumos)
    {
        while(id==-1 && fread(&c, sizeof(stConsumos), 1, pArchConsumos) > 0)
        {
            if(c.dia == dia && c.mes == mes && c.anio == anio)
            {
                id = c.id;
            }
        }
        fclose(pArchConsumos);
    }

    return id;
}
void bajaConsumo(int dia, int mes, int anio)
{
    stConsumos c;

    FILE *pArchConsumos = fopen(AR_CONSUMOS,"r+b");

    if(pArchConsumos)
    {
        fseek(pArchConsumos, sizeof(stConsumos)*buscaPosConsumo(buscaIdXFechaConsumo(dia, mes, anio)), SEEK_SET);
        fread(&c, sizeof(stConsumos), 1, pArchConsumos);
        c.baja = 1;
        fseek(pArchConsumos, sizeof(stConsumos)*buscaPosConsumo(buscaIdXFechaConsumo(dia, mes, anio)), SEEK_SET);
        fwrite(&c, sizeof(stConsumos), 1, pArchConsumos);
        fclose(pArchConsumos);
    }
}
int buscaPosConsumo(int id)
{
    int pos = -1;

    stConsumos c;

    FILE *pArchConsumos = fopen(AR_CONSUMOS, "rb");

    if(pArchConsumos)
    {
        while(pos==-1 && fread(&c, sizeof(stConsumos), 1, pArchConsumos) > 0)
        {
            if(c.id == id)
            {
                pos = ftell(pArchConsumos)/sizeof(stConsumos)-1;
            }
        }
        fclose(pArchConsumos);
    }

    return pos;
}
void cargaArchivoConsumos()
{
    stConsumos c;
    int dia = diaActual();
    int mes = mesActual();
    int anio = anioActual();

    for (int i=0; i<10 ;i++)
    {
        c = cargaUnConsumo(dia, mes, anio);

        guardaUnConsumo(c);
    }
}
int buscaUltimoIdConsumo()
{
    stConsumos c;

    int id = -1;
    FILE *pArchConsumos = fopen(AR_CONSUMOS,"rb");
    if(pArchConsumos)
    {
        fseek(pArchConsumos, sizeof(stConsumos)*(-1),SEEK_END);

        if(fread(&c,sizeof(stConsumos),1,pArchConsumos) > 0)
        {
            id = c.id;
        }
        fclose(pArchConsumos);
    }
    return id;
}
void guardaUnConsumo(stConsumos c)
{
    FILE *pArchConsumos = fopen(AR_CONSUMOS,"ab");

    if(pArchConsumos)
    {
        fwrite(&c,sizeof(stConsumos),1,pArchConsumos);
        fclose(pArchConsumos);
    }
}
int anioActual()
{
    int anio;
    printf("\nIngrese el anio corriente: ");
    scanf("%d", &anio);
    return anio;
}
int mesActual()
{
    int mes;
    printf("\nIngrese el mes corriente: ");
    scanf("%d", &mes);
    return mes;
}
int diaActual()
{
    int dia;
    printf("\nIngrese el dia corriente: ");
    scanf("%d", &dia);
    return dia;
}
int ultimoConsumoDia(int mes, int dia, int idCliente)
{
    int consumo=0;

    stConsumos c;

    FILE *pArchConsumos = fopen(AR_CONSUMOS,"rb");

    if(pArchConsumos){
        while(fread(&c,sizeof(stConsumos),1,pArchConsumos) > 0 && c.idCliente == idCliente)
        {
            if (c.mes == mes && c.dia == dia)
            {
                consumo = c.datosConsumidos;
            }
        }
        fclose(pArchConsumos);
    }

    return consumo;
}
stConsumos cargaUnConsumo(int dia, int mes, int anio)
{

    stConsumos c;

    c.id=buscaUltimoIdConsumo()+1;

    c.idCliente = rand()%buscaUltimoIdCliente();

    c.anio = anio;

    c.mes = rand()%(mes)+1;

    c.dia = rand()%30;

    c.datosConsumidos = rand()%10 + ultimoConsumoDia(c.mes, c.dia, c.idCliente);

    c.baja = 0;

    return c;
}
void muestraArchConsumos(char nombreArchivo[])
{
    printf("\nLista de consumos: \n");
    stConsumos c;

    FILE *pArchConsumo = fopen(nombreArchivo,"rb");

    if(pArchConsumo)
    {
        while(fread(&c,sizeof(stConsumos),1,pArchConsumo) > 0)
        {
            muestraUnConsumo(c);
        }
    }
    printf("\n");
}
void muestraUnConsumo(stConsumos c)
{
    printf("\n  ------------------------------------------------------------------------------------------------");
    printf("\n  ID: %d // ID Cliente: %d // Anio: %d // Mes: %d // Dia: %d // Datos consumidos: %d // Baja S/N: %s ", c.id, c.idCliente, c.anio, c.mes, c.dia, c.datosConsumidos, (c.baja)?"SI":"NO");
}

void muestraArregloString(int fil, int col, char as[][col], int v)
{
    printf("\n");

    for (int i=0; i<v; i++)
    {
        printf("%s - ", as[i]);
    }
    printf("\n");
}
void muestraArrayInt(int a[], int v)
{
    printf("\n");
    for(int i=0; i<v; i++)
    {
        printf("%d - ", a[i]);
    }
    printf("\n");
}
int arch2arrayMailsChar(int fil, int col, char email[fil][col])
{
    int v=0;
    stCliente c;

    FILE *pArchCliente = fopen(AR_CLI_BAJA,"rb");

    if(pArchCliente)
    {
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            strcpy(email[v], c.email);
            v++;
        }
        fclose(pArchCliente);
    }
    return v;
}
///Función que muestra un cliente buscado por ID:
void muestraClienteXid(int id, char nombreArchivo[])
{
    stCliente c;
    int pos = 0;
    pos = buscaPos(id, nombreArchivo);

    FILE *pArch = fopen(nombreArchivo, "rb");

    if (pArch)
    {
        fseek(pArch, sizeof(stCliente)*pos, SEEK_SET);
        fread(&c, sizeof(stCliente), 1, pArch);
        muestraUnCliente(c);
    }
}

///Función que ordena por inserción array TIPO CHAR
void ordenacionString(int fil, int col, char as[fil][col], int validos)
{
    char aux[col];

    for(int i=0; i<validos-1; i++)
    {
		for(int j=i+1; j<validos; j++)
		{
			if(strcmp(as[i], as[j]) > 0)
            {
				strcpy(aux,  as[i]);
				strcpy(as[i], as[j]);
				strcpy(as[j], aux);
			}
		}
	}

}
///Funcion que pasa a un arreglo todos los Apellidos
int arch2arrayChar(int fil, int col, char apellidos[fil][col])
{
    int v=0;
    stCliente c;

    FILE *pArchCliente = fopen(AR_CLI_ALTA,"rb");

    if(pArchCliente)
    {
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            strcpy(apellidos[v], c.apellido);
            v++;
        }
        fclose(pArchCliente);
    }
    return v;
}

///Función que ordena por inserción array TIPO INT
void ordPorInserArray(int a[], int v)
{
    int num=0;

    for (int c=0; c<v; c++)
    {
        for (int i=0; i<v; i++)
        {
            while (a[i]>a[i+1])
            {
                num=a[i];
                a[i]=a[i+1];
                a[i+1]=num;
            }
        }
    }

}
///Funcion que pasa a un arreglo todos los DNIs
int arch2array(int dni[])
{
    int v=0;
    stCliente c;

    FILE *pArchCliente = fopen(AR_CLI_ALTA,"rb");

    if(pArchCliente)
    {
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            dni[v] = c.dni;
            v++;
        }
        fclose(pArchCliente);
    }
    return v;
}
///Función que pasa clientes en alta o baja a un archivo:
void creaArchivo(char nombreArchivo[], int bajaOalta)
{
    stCliente c;

    FILE *pArchCliente = fopen(AR_CLIENTE,"rb");

    if(pArchCliente)
    {
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            if (c.baja==bajaOalta)
            {
                guardaUnCliente(c, nombreArchivo);

            }
        }
        fclose(pArchCliente);
    }

}

int cuentaRegistros(char nombreArchivo[],int dato)/// dato=sizeof tipo de dato del archivo
{
    int total=0;
    FILE *pArch = fopen(nombreArchivo,"rb");
    if(pArch != NULL)
    {
        fseek(pArch,0,SEEK_END);
        total=ftell(pArch)/dato;
        fclose(pArch);
    }

    return total;
}

///Función que da de baja un cliente
void bajaCliente(int idCliBaja)
{
    stCliente c;

    FILE *pArchCliente = fopen(AR_CLIENTE,"r+b");

    if(pArchCliente)
    {
        fseek(pArchCliente, sizeof(stCliente)*buscaPos(idCliBaja, AR_CLIENTE), SEEK_SET);
        fread(&c, sizeof(stCliente), 1, pArchCliente);
        c.baja = 1;
        fseek(pArchCliente, sizeof(stCliente)*buscaPos(idCliBaja, AR_CLIENTE), SEEK_SET);
        fwrite(&c, sizeof(stCliente), 1, pArchCliente);
        fclose(pArchCliente);
    }
}
///Función que modifica un registro
void modificaRegistro(stCliente c, int idCliente)/// En c están los datos nuevos que se quieren guardar
{                                                /// e idCliente el id del cliente cuyos datos se quieren pisar
    FILE *pArchClientes = fopen(AR_CLIENTE, "r+b");

    if(pArchClientes)
    {
        fseek(pArchClientes, sizeof(stCliente)*idCliente, SEEK_SET);
        fwrite(&c, sizeof(stCliente), 1, pArchClientes);
        fclose(pArchClientes);
    }
}

int buscaPos(int id, char nombreArchivo[])
{
    int pos = -1;

    stCliente c;

    FILE *pArchClientes = fopen(nombreArchivo, "rb");

    if(pArchClientes)
    {
        while(pos==-1 && fread(&c, sizeof(stCliente), 1, pArchClientes) > 0)
        {
            if(c.id == id)
            {
                pos = ftell(pArchClientes)/sizeof(stCliente)-1;
            }
        }
        fclose(pArchClientes);
    }

    return pos;
}
void cargaArchivoClientes(char nombreArchivo[])
{
    char opcion=0;

    stCliente c;

    while(opcion!=27)
    {
        system("cls");

        printf("\n Carga de Clientes \n");

        c = cargaUnCliente();
        c.id=buscaUltimoIdCliente()+1;

        if (existeCliente(c.nroCliente) == 0)
        {
            guardaUnCliente(c, nombreArchivo);
        }else
        {
            printf("\nEl cliente numero %d ya esta cargado.", c.nroCliente);
        }

        printf("\n\n ESC para salir ");
        opcion=getch();
    }
}
int existeCliente(int cliente)
{
    stCliente c;

    int flag = 0;

    FILE *pArchCliente = fopen(AR_CLIENTE,"rb");

    if(pArchCliente){
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            if (c.nroCliente == cliente)
            {
                flag = 1;
            }
        }
        fclose(pArchCliente);
    }
    return flag;
}
void guardaUnCliente(stCliente c, char nombreArchivo[])
{
    FILE *pArchCliente = fopen(nombreArchivo,"ab");

    if(pArchCliente != NULL)  /// if(pArchCliente)
    {
        fwrite(&c,sizeof(stCliente),1,pArchCliente);
        fclose(pArchCliente);
    }
}
int buscaUltimoIdCliente()
{
    stCliente c;

    int id = -1;
    FILE *pArchCliente = fopen(AR_CLIENTE,"rb");
    if(pArchCliente)
    {
        fseek(pArchCliente, sizeof(stCliente)*(-1),SEEK_END);

        if(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            id = c.id;
        }
        fclose(pArchCliente);
    }
    return id;
}
stCliente cargaUnCliente()
{
    stCliente c;

    do{
        printf("\n Ingrese el nro de Cliente..........: ");
        scanf(" %d", &c.nroCliente);
    }while(c.nroCliente<0 || c.nroCliente>9999999);

    printf(" Ingrese el Nombre..................: ");
    fflush(stdin);
    gets(c.nombre);

    printf(" Ingrese el Apellido................: ");
    fflush(stdin);
    gets(c.apellido);

    printf(" Ingrese el DNI.....................: ");
    scanf(" %d", &c.dni);

    do{
        printf(" Ingrese el EMail...................: ");
        fflush(stdin);
        gets(c.email);
    }while(!validaEmail(c.email));

    printf(" Ingrese el Domicilio...................: ");
    fflush(stdin);
    gets(c.domicilio);

    printf(" Ingrese el Numero de celular...........: ");
    fflush(stdin);
    gets(c.movil);

    c.baja=0;

    return c;
}
int validaEmail(char email[])
{
    int v=strlen(email);
    int i=0;
    int flag=0;
    while(i<v && flag == 0){
        if(email[i]==64){ /// =='@'
            flag=1;
        }
        i++;
    }
    return flag;
}
void muestraArch(char nombreArchivo[])
{
    printf("\nLista de clientes: \n");
    stCliente c;

    FILE *pArchCliente = fopen(nombreArchivo,"rb");

    if(pArchCliente)
    {
        while(fread(&c,sizeof(stCliente),1,pArchCliente) > 0)
        {
            muestraUnCliente(c);
        }
    }
    printf("\n");
}
void muestraUnCliente(stCliente c)
{
    printf("\n  -----------------------------------------------------------------");
    printf("\n  ID......................: %d", c.id);
    printf("\n  Nro de Cliente..........: %d", c.nroCliente);
    printf("\n  Nombre..................: %s", c.nombre);
    printf("\n  Apellido................: %s", c.apellido);
    printf("\n  DNI.....................: %d", c.dni);
    printf("\n  EMail...................: %s", c.email);
    printf("\n  Calle...................: %s", c.domicilio);
    printf("\n  Nro de Celular..........: %s", c.movil);
    printf("\n  Baja s/n................: %s", (c.baja)?"SI":"NO");
}
