from hurry.filesize import size
from urllib.parse import unquote_plus
import boto3
import json
import csv
import io
from botocore.exceptions import ClientError
import os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


  
def lambda_handler(event, context):
    
    #ESTABLECEMOS LOS DIFERENTES TIPOS DE VARIABLES
    
    records = [x for x in event.get('Records', []) if x.get('eventName') == 'ObjectCreated:Put' or x.get('eventName') == 'ObjectCreated:Post' or x.get('eventName') == 'ObjectCreated:CompleteMultipartUpload']#TODA LA CABECERA DEL DATO DE LA SUBIDA
    print(records)
    sorted_events = sorted(records, key=lambda e: e.get('eventTime'))
    latest_event = sorted_events[-1] if sorted_events else {}#ULTIMO EVENTO OCURRIDO EN FORMATO JSON
    info = latest_event.get('s3', {})
    #fecha = info.get('eventTime')
    fecha = event['Records'][0]['eventTime']#MOMENTO DONDE SE SUBIÓ
    file_key = info.get('object', {}).get('key')#DIRECCION DE SUBIDA DE FICHERO
    nombreFichero = unquote_plus(info.get('object', {}).get('key', '1/2/3').split("/")[2])#NOMBRE DEL FICHERO
    tamanyo = size(event['Records'][0]['s3']['object']['size'])#TAMAÑO DEL FICHERI
    tamanyoSinT = event['Records'][0]['s3']['object']['size']
    persona = file_key.split("/")[0]#PERSONA DE ORIGEN DE SUBIDA
    nombreBucket= info.get('bucket', {}).get('name')
    tipo =file_key.split("/")[1]#TIPO DE SUBIDA ESCRITURA Y LECTURA
    #bucket_name = info.get('bucket', {}).get('name')
    
    source_dir= "{}/escritura/{}".format(persona,nombreFichero)
    source_dir2 = "{}/{}/escritura/{}".format(nombreBucket,persona,nombreFichero)#ORIGEN CON CABECERA
    target_dir = "profesor/{}".format(nombreFichero)#DESTINO

    # let's say you have a new file in Landing folder, the s3 uri is
    #s3_uri = "s3://sftps3mixer/"+file_key
    s3_uri = "s3://{}/{}".format(nombreBucket, file_key)#ORIGEN CON CABECERA

    
    #CORREO PROCEDENTE
    
    sender_email_address = 'suhartx@gmail.com'
    
    #CORREO OBJETIVO
  
    receiver_email_address = 'suhartx@gmail.com'
  
  
    aws_region_name = "eu-west-1"
  

    
    #COMPROBANTE SI ES ALUMNO
    
    if persona.__eq__("alumnos"):
        persona = file_key.split("/")[1]
        tipo =file_key.split("/")[2]
        nombreFichero = unquote_plus(info.get('object', {}).get('key').split("/")[3])
        source_dir= "{}/{}/{}/{}".format(file_key.split("/")[0],persona,tipo,nombreFichero)
        target_dir = "profesor/{}".format(nombreFichero)
        source_dir2="{}/{}".format(nombreBucket, source_dir)
        
     #CABECERA DEL CORREO
  
    email_subject = "Subida {}".format(persona)
  
    #MENSAJE
  
    html_body = ("<html>"
        "<body>"
        "<p>Dear Admin,</p>"
        "<br>"
        "<p>{} Ha subido un nuevo fichero llamado {} en la fecha {} y tiene un tamaño de {}.</p>"
        "<p></p>"
        "<p></p>"
        "<p>s3_uri: {} source_dir: {} target_dir: {}</p>"
        "<p>tipo: {}</p>"
        "<p>nombrefichero: {}</p>"
        "<p>nombrefichero vacio ?{}</p>"
        "<p>condiciones():{}</p>"
        "</body>"
        "</html>").format(persona,nombreFichero,fecha,tamanyo,s3_uri,source_dir, target_dir, tipo, nombreFichero, (nombreFichero.__eq__("")) , persona.__eq__("profesor") or tipo.__eq__("lectura")or (tipo.__eq__("escritura") and (nombreFichero.__eq__("")) ))
 
 
    charset = "UTF-8"
  
  
  
    ses_resource = boto3.client('ses', region_name = aws_region_name)
    
    
  
    try:
        if (nombreFichero.__eq__("")or tamanyoSinT==0):
            print("mal")
        else:
            #ENVIO DE MENSAJE
            
            response = ses_resource.send_email(
                    Destination = {
                        'ToAddresses': [
                            receiver_email_address,
                        ],
                    },
                    Message = {
                        'Body': {
                            'Html': {
                                'Charset': charset,
                                'Data': html_body,
                            },
                        },
                        'Subject': {
                            'Charset': charset,
                            'Data': email_subject,
                        },
                    },
                    Source = sender_email_address,
                )
            
        if persona.__eq__("profesor") or tipo.__eq__("lectura")or (tipo.__eq__("escritura")and (nombreFichero.__eq__(""))  or tamanyoSinT==0):
            print("mal")
        else:
            #PREOCEDIMIENTO DE REUBICACIÓN DEL FICHERO
            s3_resource = boto3.resource('s3')
            print("funtziona")
            s3_resource.Object(nombreBucket, target_dir).copy_from(
            CopySource=source_dir2)
            print("hasta aqui")
            # Delete the former object A
            s3_resource.Object(nombreBucket, source_dir).delete()   
            
  
    except ClientError as e:
        print("Email Delivery Failed! ", e.response['Error']['Message'])
    else:
        print("Email successfully sent to " + receiver_email_address + "!" + persona)
        


