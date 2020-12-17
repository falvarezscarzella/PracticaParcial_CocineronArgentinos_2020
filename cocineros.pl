% BASE DE CONOCIMIENTOS

/*
Plato principal del cual conocemos el nombre de la comida y la cantidad de calorías.

Entrada de la cual sabemos el nombre, los ingredientes y la cantidad de calorías.

Postre del cual se conoce el nombre, el sabor principal y la cantidad de calorías que aporta.
*/

%cocina(nombre, plato, puntos)
cocina(mariano, principal(nioquis, 50), 80).
cocina(julia, principal(pizza, 100), 60).
cocina(hernan, postre(panqueque, dulceDeLeche, 100), 60).
cocina(hernan, postre(trufas, dulceDeLeche, 60), 80).
cocina(hernan, entrada(ensalada, [tomate, zanahoria, lechuga], 70), 29).
cocina(susana, entrada(empanada, [carne, cebolla, papa], 50), 50).
cocina(susana, postre(pastelito, dulceDeMembrillo, 50), 60).
cocina(melina, postre(torta, zanahoria, 60),50).

%popular(plato)
popular(carne).
popular(dulceDeLeche).
popular(dulceDeMembrillo).

%esIngrediente(Ingrediente)
esIngrediente(Ingrediente):- cocina(_,postre(_,Ingrediente,_),_).
esIngrediente(Ingrediente):- cocina(_,entrada(_,Ingredientes,_),_), member(Ingrediente,Ingredientes).

%amigo(cocinero,amigo)
amigo(mariano, susana).
amigo(mariano, hernan).
amigo(hernan, pedro).
amigo(melina, carlos).
amigo(carlos, susana).

% PUNTO 1

esSaludable(Comida):-
    cocina(_,Comida,_),
    platoSaludable(Comida).

platoSaludable(principal(_,Calorias)):-
    Calorias >= 70,
    Calorias =< 90.
platoSaludable(entrada(_,_,Calorias)):-
    Calorias =< 60.
platoSaludable(postre(_,_,Calorias)):-
    Calorias < 100.

% PUNTO 2

soloSalado(Cocinero):-
    cocina(Cocinero,_,_),
    not(cocina(Cocinero,postre(_,_,_),_)).
    
% PUNTO 3

puntosCocinero(Cocinero,PuntosTotales):-
    cocina(Cocinero,_,_),
    findall(Puntos, cocina(Cocinero,_,Puntos), ListaPuntos),
    sumlist(ListaPuntos,PuntosTotales).
    
tieneUnaGranFama(Cocinero):-
    puntosCocinero(Cocinero,MejorPuntaje),
    forall((puntosCocinero(OtroCocinero,Puntaje),OtroCocinero \= Cocinero),Puntaje < MejorPuntaje).

% PUNTO 4

noEsSaludable(Cocinero):-
    cocina(Cocinero,Plato,_),
    esSaludable(Plato),
    forall((cocina(Cocinero,OtroPlato,_),OtroPlato \= Plato),not(esSaludable(OtroPlato))).

% PUNTO 5

tieneIngredientePopular(entrada(_,Ingredientes,_)):- member(Ingrediente,Ingredientes), popular(Ingrediente).
tieneIngredientePopular(postre(_,Ingrediente,_)):- popular(Ingrediente).

noUsaIngredientesPopulares(Cocinero):-
    cocina(Cocinero,_,_),
    forall(cocina(Cocinero,Plato,_),not(tieneIngredientePopular(Plato))).

% PUNTO 6

platoUsaIngrediente(entrada(_,Ingredientes,_),Ingrediente):-
    member(Ingrediente,Ingredientes).
platoUsaIngrediente(postre(_,Ingrediente,_),Ingrediente).

ingredientePopularMasUsado(Cocinero,Ingrediente):-
    cocina(Cocinero,Plato,_),
    esIngrediente(Ingrediente),
    popular(Ingrediente),
    platoUsaIngrediente(Plato,Ingrediente).

% PUNTO 7

esAmigo(Cocinero,Colega):- amigo(Cocinero,Colega).
esAmigo(Cocinero,Colega):- amigo(Cocinero,AmigoComun), esColega(AmigoComun,Colega).

esRecomendadoPorColega(Cocinero,Recomendador):-
    cocina(Cocinero,_,_),
    cocina(Recomendador,_,_),
    not(noEsSaludable(Cocinero)),
    esAmigo(Cocinero,Recomendador).
