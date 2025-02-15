def dibujar_cuadricula(n, coordenadas_x, coordenadas_c):
    # Inicializar la cuadrícula con puntos '.'
    cuadricula = [['.' for _ in range(n)] for _ in range(n)]
    
    # Marcar las coordenadas con 'X'
    for (x, y) in coordenadas_x:
        if 0 <= x < n and 0 <= y < n:  # Verificar que las coordenadas estén dentro de la cuadrícula
            cuadricula[y][x] = 'X'
        else:
            print(f"Advertencia: La coordenada ({x}, {y}) para 'X' está fuera de la cuadrícula y será ignorada.")
    
    # Marcar las coordenadas con 'C'
    for (x, y) in coordenadas_c:
        if 0 <= x < n and 0 <= y < n:  # Verificar que las coordenadas estén dentro de la cuadrícula
            if cuadricula[y][x] == 'X':
                print(f"Advertencia: La coordenada ({x}, {y}) ya está marcada con 'X' y no se puede marcar con 'C'.")
            else:
                cuadricula[y][x] = 'C'
        else:
            print(f"Advertencia: La coordenada ({x}, {y}) para 'C' está fuera de la cuadrícula y será ignorada.")
    
    # Dibujar la cuadrícula
    for fila in cuadricula:
        print(' '.join(fila))
    
    # Devolver la cuadrícula modificada (opcional)
    return cuadricula

'''un enfoque con BFS implicaría que luego de obtener todos los estados validos para el primer caballo, 
para el segundo debemos probar todas las posiciones válidas a partir de cada estado válido de 1 caballo. 
Para el tercer caballo se deberíamos probar todas las posiciones a partir de cada estado válido de 2 caballos. 
Así sucesivamente hasta que no podamos poner mas caballos.

Para la practica usaremos un enfoque con DFS en el que la ejecución del programa se interrumpe cuando ponemos 
la cantidad máxima de caballos.

Al aplicar DFS, nos referimos a que despues del primer caballo, ponemos el segundo sin probar más configuraciones
para 1 caballo y ponemos el segundo, después de poner el segundo ponemos el tercero sin probar más configuraciones
para 2 caballos. Así sucesivamente hasta que no haya lugar para ningún caballo.

El algoritmo que seguiremos es el siguiente:
n es la cantidad de filas y columnas el tablero
x,y es la casilla actual
Siempre empezamos con x = -1,y = -1
Si x + 1 == n :
    
    Si y + 1 < n: 
        x = 0
        y = y + 1 // haciendo un cambio de renglon.

    Si y + 1 == n // quiere decir que ya pasamos todas las casillas del tablero y acaba el programa.
        FIN DEL PROGRAMA

Si x + 1 < n:
    x = x + 1.

Se verifica que (x,y) no este en la lista de puntos "invalidos".
Los puntos invalidos son: 
puntos donde un caballo ocupa un lugar
puntos donde si ponemos un caballo, este sera atacado
Si (x,y) esta en la lista de prohibidos NO ponemos caballo y pasamos a la siguiente casilla.
En caso contrario ''ponemos'' un caballo en la casilla actual.
Se ''tacha'' la casilla donde este se posiciona (agregamos el punto a la lista de caballos y puntos prohibidos)
Se ''tachan'' las casillas donde el caballo ataca (agregamos el punto a la lista de casillas de ataque y puntos prohibidos)
Pasamos a la siguiente casilla.
Al terminar imprimimos el tablero n x n marcando caballos, puntos libres (si los hay) y casillas de ataque
'''
def coordenada_no_en_lista(x, y, lista_coordenadas):
    """
    Verifica si la coordenada [x, y] no está en la lista de coordenadas.

    Parámetros:
        x (int): Coordenada x.
        y (int): Coordenada y.
        lista_coordenadas (list): Lista de coordenadas en formato [[x1, y1], [x2, y2], ...].

    Retorna:
        bool: True si [x, y] no está en la lista, False si sí está.
    """
    return [x, y] not in lista_coordenadas

def superCaballo(x,y,listaPuntosOcupados,listaCaballos,listaAtaque,n):
    
    if coordenada_no_en_lista(x,y,listaPuntosOcupados) == True:
        listaPuntosOcupados.append([x,y])
        listaCaballos.append([x,y])
        if (x-2 >= 0) and (y-2 >= 0):
            listaPuntosOcupados.append([x-2,y-2])
            listaAtaque.append([x-2,y-2])

        if (x-2 >= 0) and (y+2 < n):
            listaPuntosOcupados.append([x-2,y+2])
            listaAtaque.append([x-2,y+2])
        
        if (x+2 < n) and (y-2 >= 0):
            listaPuntosOcupados.append([x+2,y-2])
            listaAtaque.append([x+2,y-2])

        if (x+2 < n) and (y+2 < n):
            listaPuntosOcupados.append([x+2,y+2])
            listaAtaque.append([x+2,y+2]) 
    #print(listaCaballos,listaAtaque)
    if x + 1 == n :
    
        if y + 1 < n: 
            x = 0
            y = y + 1 # haciendo un cambio de renglon.
        
        else:#y + 1 == n:
            return [listaCaballos,listaAtaque]
        
    else: #x + 1 < n
        x = x + 1

    return superCaballo(x,y,listaPuntosOcupados,listaCaballos,listaAtaque,n)
numero = int(input("Introduce un número entero para definir el tamaño del tablero: "))
l = superCaballo(0,0,[],[],[],numero)
dibujar_cuadricula(numero,l[1],l[0])