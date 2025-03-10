import random
def dibujar_cuadricula(n, coordenadas_x, coordenadas_c):
    # Inicializar la cuadrícula con puntos '.'
    cuadricula = [['.' for _ in range(n)] for _ in range(n)]
    
    # Marcar las coordenadas con 'X'
    for (x, y) in coordenadas_x:
        if 0 <= x < n and 0 <= y < n:  # Verificar que las coordenadas estén dentro de la cuadrícula
            cuadricula[y][x] = 'X'
        else:
            print(f"Advertencia: La coordenada ({x}, {y}) para 'X' está fuera de la cuadrícula y será ignorada.")
    c = 0
    # Marcar las coordenadas con 'C'
    for (x, y) in coordenadas_c:
        if 0 <= x < n and 0 <= y < n:  # Verificar que las coordenadas estén dentro de la cuadrícula
            if cuadricula[y][x] == 'X':
                print(f"Advertencia: La coordenada ({x}, {y}) ya está marcada con 'X' y no se puede marcar con 'C'.")
            else:
                cuadricula[y][x] = 'C'
                c += 1
        else:
            print(f"Advertencia: La coordenada ({x}, {y}) para 'C' está fuera de la cuadrícula y será ignorada.")
    
    # Dibujar la cuadrícula
    for fila in cuadricula:
        print(' '.join(fila))
    
    print(f"CANTIDAD DE CABALLOS EN EL TABLERO: {c}")
    # Devolver la cuadrícula modificada (opcional)
    return cuadricula

def eliminar_par_ordenado(lista_eliminar, lista_pares):
    for (x,y) in lista_eliminar:
        if (x,y) in lista_pares:
            lista_pares.remove((x,y))
    return lista_pares

def crear_lista_de_casillas(n):
    l = []
    for i in range(0,n):
        for j in range(0,n):
            l.append((i,j))
    return l

'''print(eliminar_par_ordenado([(1,2),(1,1)],[(3,4),(1,2),(1,1)]))
a = crear_lista_de_casillas(2)
e = random.choice(a)
print(eliminar_par_ordenado([e],a))'''
def DFS_supercaballo(n,listaCasillasDisponibles,x,y,listaCaballos,listaAtaques):
    eliminar_par_ordenado([(x,y),(x-2,y-2),(x-2,y+2),(x+2,y-2),(x+2,y+2)],listaCasillasDisponibles)
    listaCaballos.append([x,y])
    
    if (x-2 >= 0) and (y-2 >= 0):
        listaAtaques.append([x-2,y-2])

    if (x-2 >= 0) and (y+2 < n):
        listaAtaques.append([x-2,y+2])
        
    if (x+2 < n) and (y-2 >= 0):
        listaAtaques.append([x+2,y-2])

    if (x+2 < n) and (y+2 < n):
        listaAtaques.append([x+2,y+2])

    if len(listaCasillasDisponibles) > 0:
        proxima_casilla = random.choice(listaCasillasDisponibles)
        x = proxima_casilla[0]
        y = proxima_casilla[1]
        return DFS_supercaballo(n,listaCasillasDisponibles,x,y,listaCaballos,listaAtaques)
    
    else:
        return [listaCaballos,listaAtaques]

numero = int(input("Introduce un número entero para definir el tamaño del tablero: "))
l = crear_lista_de_casillas(numero)
l = DFS_supercaballo(numero,l,random.randint(0,numero-1),random.randint(0,numero-1),[],[])
dibujar_cuadricula(numero,l[1],l[0])
