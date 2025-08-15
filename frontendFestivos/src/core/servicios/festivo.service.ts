import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { FestivoDto } from '../../shared/entidades/festivo-dto';
import { Festivo } from '../../shared/entidades/festivo';

@Injectable({
  providedIn: 'root'
})
export class FestivoService {

  url: string;

  constructor(private http: HttpClient) {
    this.url = `${environment.urlService}festivos/`;
  }

  public verificarFecha(idPais: number, fecha: Date): Observable<boolean> {
    let año = fecha.getFullYear();
    let mes = fecha.getMonth() + 1;
    let dia = fecha.getUTCDate();
    let urlT = `${this.url}verificar/${idPais}/${año}/${mes}/${dia}`;
    return this.http.get<boolean>(urlT);
  }

  public obtenerFestivos(idPais: number, año: number): Observable<FestivoDto[]> {
    let urlT = `${this.url}listar/${idPais}/${año}`;

    return this.http.get<FestivoDto[]>(urlT);
  }

  public listar(): Observable<Festivo[]> {
    return this.http.get<Festivo[]>(`${this.url}listar`);
  }

  public buscar(dato: String): Observable<Festivo[]> {
    return this.http.get<Festivo[]>(`${this.url}buscar/${dato}`);
  }

  public agregar(seleccion: Festivo): Observable<Festivo> {
    return this.http.post<Festivo>(`${this.url}agregar`, seleccion);
  }

  public modificar(seleccion: Festivo): Observable<Festivo> {
    return this.http.put<Festivo>(`${this.url}modificar`, seleccion);
  }

  public eliminar(idFestivo: number): Observable<boolean> {
    return this.http.delete<boolean>(`${this.url}eliminar/${idFestivo}`);
  }

}
