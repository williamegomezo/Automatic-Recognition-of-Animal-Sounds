$(document).ready(function(){

	$('#atras').click(function(){
		back = $("#atras").attr('name')
		$("#graficar").attr("disabled", 'disabled');
		$("#kmeans").attr("disabled", 'disabled');
		$("#segmentacion").attr("disabled", 'disabled');
		back = back.split('/')
		if(back.length > 1){
			back.pop()
			back = back.toString()
			back = back.replace(",", "/");
			$("#atras").attr("name", back);
		}else{
			back = ''
		}
		consulta(back)
	});

	$('#graficar').click(function(){
		audio = $("#graficar").attr('name')
		channel = $("#channel").attr('name')
		grafica(audio, channel)
		$("#consulta").attr("name", audio);
	});

	$('#kmeans').click(function(){
		audio = $("#atras").attr('name')
		audioA = audio.split('/')
		audioA = audioA[0]
		channel = $("#channel").attr('name')
		kmeans(audioA, channel)
		$("#consulta").attr("name", audio);
	});

	$('#segmentacion').click(function(){
		audio = $("#graficar").attr('name')
		channel = $("#channel").attr('name')
		segmentacion(audio, channel)
		$("#consulta").attr("name", audio);
	});

	$('#channel').change(function(){
		val = $(this).val()
		$('#channel').attr("name", val);
	});

	$('#consulta').change(function(){
		$('#atras').removeAttr('disabled');
		name = $(this).val()
		if((name.indexOf('.wav') == -1) && (name.indexOf('.mp3') == -1)){
			consulta(name)
		}else{
			$('#graficar').attr("name", name);
			$('#graficar').removeAttr('disabled');
			$('#kmeans').removeAttr('disabled');
			$('#segmentacion').removeAttr('disabled');
			channelFun(name);
		}
	});

	function kmeans(audio, channel){
		$.ajax({
		type: 'get',
		url: 'kmeans/',
		data: {
			'audio':audio,
			'channel':channel,
		},
		beforeSend: function(jqXHR, settings){
			$("#spinnerK").attr("class", "spinningCircle")
			$("#kmeans").attr("disabled", 'disabled');
			$("#text-buttonK").html("")
		},
		complete: function(jqXHR, textStatus){
			$("#spinnerK").attr("class", "")
			$('#kmeans').removeAttr('disabled');
			$("#text-buttonK").html("K-Means")
		},
		success: function (response){
			$('#ModalCenterKmeans').modal('show')
			$("#kmeansgraph").attr("src", "data:image/png;base64," + response)
		},
		error: function(xhr, status, error){
			console.log(xhr.responseText);
			console.log(status);
			console.log(error);
		}
		});
	}

	function segmentacion(audio, channel){
		$.ajax({
		type: 'get',
		url: 'segmentacion/',
		data: {
			'audio':audio,
			'channel':channel,
		},
		beforeSend: function(jqXHR, settings){
			$("#spinnerS").attr("class", "spinningCircle")
			$("#segmentacion").attr("disabled", 'disabled');
			$("#text-buttonS").html("")
		},
		complete: function(jqXHR, textStatus){
			$("#spinnerS").attr("class", "")
			$('#segmentacion').removeAttr('disabled');
			$("#text-buttonS").html("Segmentacion")
		},
		success: function (response){
			$('#ModalCenterSegmentacion').modal('show')
			$("#segmentaciongraph").attr("src", "data:image/png;base64," + response)
		},
		error: function(xhr, status, error){
			console.log(xhr.responseText);
			console.log(status);
			console.log(error);
		}
		});
	}

	function channelFun(audio){
		$.ajax({
		type: 'get',
		url: 'channel/',
		data: {
			'audio':audio,
		},
		error: function(xhr, status, error){
			console.log(xhr.responseText);
			console.log(status);
			console.log(error);
		},
		success: function (response){
			$("#channel").html('');
			for(var i = 1; i <= parseInt(response); i++){
				$("#channel").append("<option value='"+i+"'>"+i+"</option>")
			}
			$('#channel').attr("name", 1);
		}
		});
	}

	function grafica(audio, channel){
		$.ajax({
		type: 'get',
		url: 'graficar/',
		data: {
			'audio':audio,
			'channel':channel,
		},
		beforeSend: function(jqXHR, settings){
			$("#spinner").attr("class", "spinningCircle")
			$("#graficar").attr("disabled", 'disabled');
			$("#text-button").html("")
		},
		complete: function(jqXHR, textStatus){
			$("#spinner").attr("class", "")
			$('#graficar').removeAttr('disabled');
			$("#text-button").html("Spectrogram")
		},
		success: function (response){
			$('#ModalCenter').modal('show')
			$("#grafica").attr("src", "data:image/png;base64," + response)
		},
		error: function(xhr, status, error){
			console.log(xhr.responseText);
			console.log(status);
			console.log(error);
		}
		});
	}

	function consulta(name){

		var month = [];
		var day = [];
		var year = [];
		var hour = [];

		$.ajax({
		type: 'get',
		url: 'consulta/',
		data: {
			'file':name,
		},
		error: function(xhr, status, error){
			console.log(xhr.responseText);
			console.log(status);
			console.log(error);
		},
		success: function (response){
			var cont = 0;

			var json = JSON.parse(response);

			$("#consulta").html('');
			$("#atras").attr("name", name);

			for (var file in json) {
				if(json[file].indexOf('.') == -1){
					$("#consulta").append("<option value='"+name+"/"+json[file]+"'>"+json[file]+"</option>")
				}else{
					if((json[file].indexOf('.wav') != -1) || (json[file].indexOf('.mp3') != -1)){
						date = json[file].split('_')
						dateTime = date[1]
						time = date[2]

						year.push(dateTime.substring(0, 4));
						month.push(parseInt(dateTime.substring(4, 6), 10));
						day.push(parseInt(dateTime.substring(6, 8), 10));

						hour.push(parseInt(time.substring(0, 2), 10));

						
						cont =  cont + 1;

						$("#consulta").append("<option value='"+name+"/"+json[file]+"'>"+json[file]+"</option>")
					}
				}
			}

			year = Array.from(new Set(year.sort()));
			month = Array.from(new Set(month.sort()));
			day = Array.from(new Set(day.sort()));
			hour = Array.from(new Set(hour.sort()));

			$("#nFiles").html(cont)
			$("#years").html(Math.min(year) + '-' + Math.max(year))
			$("#months").html(moment(new Date(0000, Math.min(year), 00)).format("MMM") + '-' + moment(new Date(0000, Math.max(year), 00)).format("MMM"))
			$("#days").html(Math.min(day) + '-' + Math.max(day))
			$("#hours").html(Math.min.apply(null, hour) + '-' + Math.max.apply(null, hour))
		}
		});
	}
});