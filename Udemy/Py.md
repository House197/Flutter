``` py

params = {
    'id_area': id_area,
    'id_partnumber' :id_partnumber,
    'date': date_today,
    'table': db_table,
    'is_simulation': is_simulation,
    'shifts_enabled': shifts_enabled.
    'simultaneous': simultaneous,
    'simultaneous2': simultaneous2 
}

""" 	shiftsEnabled[0] = getPathValue('event.source.Schedule.getValueAt(0,"Turno1")')
	shiftsEnabled[1] = getPathValue('event.source.Schedule.getValueAt(0,"Turno2")')
	shiftsEnabled[2] = getPathValue('event.source.Schedule.getValueAt(0,"Turno3")') """

def redistributeProduction():
	id_line = params['id_area']	
	id_partnumber = params['id_partnumber']
	Date = params['date']
	table = params['table']
    is_simulation = params['is_simulation']
    shiftsEnabled = params['shifts_enabled']
    simultaneous = params['simultaneous']
    simultaneous2 = params['simultaneous2']

	logger = system.util.getLogger('Redistribution')

    tabla_part, tabla_rates = ['partnumber_sim', 'PP_RatesxPartnumber_sim'] if is_simulation else ['partnumber', 'PP_RatesxPartnumber']	
	
	PartProductionQuery = 'SELECT SUM(quantity) FROM ' + table + ' WHERE id_partnumber = ? AND entry_date = ? AND id_type = 3 AND id_line = ?'
	shiftCapQuery = 'SELECT eficiencia8x8 * piezas_xhora FROM '+tabla_rates+' INNER JOIN '+tabla_part+' ON '+tabla_rates+'.id_partnumber = '+tabla_part+'.id_partnumber WHERE id_c_partnumber = ? and id_turno = ? and '+tabla_part+'.id_line = ?'
	simultaneous2Query = 'SELECT Simultaneous2 FROM '+tabla_part+' WHERE id_c_partnumber = ? AND id_line = ?'
	Simultaneous2PartListQuery = 'SELECT id_c_partnumber FROM '+tabla_part+' WHERE Simultaneous2 = ? AND id_line = ?'
	inventoryQuery = "SELECT SUM(quantity) FROM " + table + " WHERE (entry_date < ? AND id_partnumber = ?) or  (entry_date = ? AND id_partnumber = ? AND id_type = 2)"
	
	shiftCapacities = [0,0,0]
	productionStation = [0,0,0]
	
	shift1End = system.date.setTime(Date,15,0,0)
	shift2End = system.date.setTime(Date,22,0,0)
	shift3End = system.date.addDays(Date,1)
	shift3End = system.date.setTime(shift3End,7,0,0)
	
	currentDate = system.date.now()
	if Date < currentDate:
		if shift1End < currentDate:
			shiftsEnabled[0] = 0
		if shift2End < currentDate:
			shiftsEnabled[1] = 0
		if shift3End < currentDate:
			shiftsEnabled[2] = 0
									
		
	
	if simultaneous != 0:
		partnumbersNotSimultaneous = simultaneous_list.getColumnAsList(0)
	else:
		partnumbersNotSimultaneous = [id_partnumber]
	partnumbersSimultaneous = simultaneous2_list.getColumnAsList(0)
	
	initDayProduction = getDBInfo(PartProductionQuery,[id_partnumber,Date,id_line],'Part ID: ' + str(id_partnumber) + ' Production')
	
    #-----statusStr = '<html>initialProduction:'+str(initDayProduction)+ '<br> oldPP[' + str(event.source.PP_S1) +','+str(event.source.PP_S2) +','+str(event.source.PP_S3) +'] '
	
	maxSim = 0
	maxSimList = []
	minInvList = []
	ProductionDictionary = {}
	# esta parte se queda como documentación de si primero se requiere la mayor produccion, se reemplaza para buscar el de menor demanda
	for id_part in partnumbersNotSimultaneous: #buscamos de los que no se producen al mismo tiempo el mayor de cada uno para sacar la proporcion
		maxProduction = 0
		minInventory = 'ND'
		print 'id part no simultaneo ',id_part
		Simultaneous2 = getDBInfo(simultaneous2Query,[id_part,id_line],'Part ID: ' + str(id_part) + ' Simultaneous2') #sacamos los que se producen con este mismo np		
		if Simultaneous2 != 0: #si tiene 0 significa que es independiente a cualquier np			
			simultaneous2PartList = system.db.runPrepQuery(Simultaneous2PartListQuery,[Simultaneous2,id_line]).getColumnAsList(0) #sacamos los id_part para los iguales
			for id_part2 in simultaneous2PartList:				
				productionsimultaneous2 = getDBInfo(PartProductionQuery,[id_part2,Date,id_line],'Part ID: ' + str(id_part2) + ' Production Simultaneous2') #sacamos la planeacion para el simultaneo
				inventorysimultaneous2 = getDBInfo(inventoryQuery,[Date,id_part2,Date,id_part2],'Part ID: ' + str(id_part2) + ' Inventory Simultaneous2') #sacamos la planeacion para el simultaneo
				
				print 'inventorysimultaneous2',inventorysimultaneous2
				print 'id parts simultaneo',id_part2,productionsimultaneous2
				if productionsimultaneous2 > maxProduction:
					maxProduction = productionsimultaneous2 #el np simultaneo con mayor produccion
				if minInventory == 'ND': #solo para inicializar
					minInventory = inventorysimultaneous2
				if inventorysimultaneous2 < minInventory:
					minInventory = inventorysimultaneous2
					
		else:
			maxProduction = getDBInfo(PartProductionQuery,[id_part,Date,id_line],'Part ID: ' + str(id_part) + ' Production')
			minInventory = getDBInfo(inventoryQuery,[Date,id_part,Date,id_part],'Part ID: ' + str(id_part) + ' Inventory') #sacamos la planeacion para el simultaneo
			print inventoryQuery,Date,id_part
		print 'id parts simultaneo max', maxProduction
		maxSimList.append(maxProduction) #para testing
		
		minInvList.append(minInventory)
		maxSim += maxProduction #para el total del dia con maximos
		
		ProductionDictionary[id_part] = {'productionDay':maxProduction,#produccion del día para ese numero de parte en base a todos los demas que se deben producr en pares
												'shiftsProduction':[0,0,0],'inventory':minInventory}
	statusStr += ('<br> - shiftsEnabled' + str(shiftsEnabled) + ' - '	)										
	#buscamos en sus similares el 
	print 'minInventory',minInventory
	print 'minInvList',minInvList

	listProduction = []
	for id_part in ProductionDictionary:
		temp = [id_part,ProductionDictionary[id_part]['productionDay'],ProductionDictionary[id_part]['inventory']] #generamos una lista para poder ordenar por produccion para darle prioridad al np por inventario
		listProduction.append(temp) #[id_part,production day]
	SortedProduction = sorted(listProduction, key=lambda x:x[2], reverse = False) #ordenamos
	print SortedProduction
	shiftCapacitiesTemp = [0,0,0]
	for partProduction in SortedProduction:			
		productionPart = partProduction[1] # 1 es produccion 0 es el id
		for shift in range(0,len(shiftCapacities)): #ahora primero recorremos los turnos para ir ordenando la produccion
			if shiftsEnabled[shift]: #si esta habilitado el turno
				shiftCapacityTemp = int(getDBInfo(shiftCapQuery,[partProduction[0],shift+1,id_line],'Part ID: ' + str(partProduction[0]) + ' Query Capacities for shift '+ str(shift+1)))
				
				if productionStation[shift] == 0  or (productionStation[shift] != 0 and shiftCapacities[shift] - productionStation[shift] > 0 and shiftCapacityTemp < shiftCapacities[shift]):# si no se ha asignado le ponemos el del current				
					shiftCapacities[shift] = shiftCapacityTemp
				print shiftCapacities
				shiftCapacity = shiftCapacities[shift] #sacamos capacidad del turno 
				print 'Part ID: ' + str(partProduction[0]) + ' Query Capacities for shift '+ str(shift+1) +' '+ str(shiftCapacity)
				asignedProduction = productionStation[shift]  #sacamos lo que ya fue asignado para ese turno
				remainingAvailableProduction = shiftCapacity - asignedProduction #aqui calculamos lo que aun podemos asignar para el turno
				if remainingAvailableProduction < 0:
					remainingAvailableProduction = 0
				if productionPart - remainingAvailableProduction < 0: # si ya se acaba la produccion en el turno 
					productionShiftPart = productionPart
					productionPart = 0
				
				else:
					productionShiftPart = remainingAvailableProduction # se le asigna lo que queda disponible para el turno
					productionPart = productionPart - remainingAvailableProduction #restamos lo que ya se asigno a la produccion total
					
					
				ProductionDictionary[partProduction[0]]['shiftsProduction'][shift] = productionShiftPart
				
				productionStation[shift] = asignedProduction + productionShiftPart
				
	print 	ProductionDictionary
	print 'shiftCapacities',shiftCapacities
	statusStr += ('<br> - shiftCapacities' + str(shiftCapacities) + ' - '	)	
	
	
	dayCapacity = 0
	
	if shiftsEnabled[0]:
		dayCapacity += shiftCapacities[0]
	if shiftsEnabled[1]:
		dayCapacity += shiftCapacities[1]
	if shiftsEnabled[2]:
		dayCapacity += shiftCapacities[2]
	
	multToMaxCap = 1.0
	
	if maxSim > dayCapacity: #sacamos la proporcional en caso de que nos pasemos de la capacidad para multiplicar cada np
		multToMaxCap = float(dayCapacity)/float(maxSim)
	
	print 'dayCapacity',dayCapacity
	print 'multToMaxCap',multToMaxCap
	
	#for id_part in ProductionDictionary:
		#ProductionDictionary[id_part]['productionDay'] *= multToMaxCap
		#ProductionDictionary[id_part]['productionDay'] = int(ProductionDictionary[id_part]['productionDay'])
	
	#print ProductionDictionary
	statusStr += ('<br> - newPP' + str(ProductionDictionary[id_partnumber]['shiftsProduction']) + ' - '	)
	
	
	UpdateProductionQuery = 'UPDATE ' + table + ' SET quantity = ? WHERE id_line = ? AND id_partnumber = ? AND entry_date = ? AND id_shift = ? AND id_type = 3'
	if id_partnumber in ProductionDictionary:
		#-----statusStr += '<br>FinalProduction:'+ str(ProductionDictionary[id_partnumber]['productionDay'])
		#-----event.source.getComponent('Group 9').getComponent('DOH Plan').toolTipText = statusStr
		print [ProductionDictionary[id_partnumber]['shiftsProduction'][0],id_line,id_partnumber,Date,1]
		print [ProductionDictionary[id_partnumber]['shiftsProduction'][1],id_line,id_partnumber,Date,2]
		print [ProductionDictionary[id_partnumber]['shiftsProduction'][2],id_line,id_partnumber,Date,3]
		system.db.runPrepUpdate(UpdateProductionQuery,[ProductionDictionary[id_partnumber]['shiftsProduction'][0],id_line,id_partnumber,Date,1])
		system.db.runPrepUpdate(UpdateProductionQuery,[ProductionDictionary[id_partnumber]['shiftsProduction'][1],id_line,id_partnumber,Date,2])
		system.db.runPrepUpdate(UpdateProductionQuery,[ProductionDictionary[id_partnumber]['shiftsProduction'][2],id_line,id_partnumber,Date,3])
		pass
```