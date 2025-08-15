import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Pais } from '../../shared/entidades/pais';

@Injectable({
  providedIn: 'root'
})
export class PaisService {
  private url: string;

  constructor(private http: HttpClient) {
    this.url = `${environment.urlService}paises/`;
  }

  public listar(): Observable<Pais[]> {
    return this.http.get<Pais[]>(`${this.url}listar`);
  }

  public buscar(dato: String): Observable<Pais[]> {
    return this.http.get<Pais[]>(`${this.url}buscar/${dato}`);
  }

  public agregar(seleccion: Pais): Observable<Pais> {
    return this.http.post<Pais>(`${this.url}agregar`, seleccion);
  }

  public modificar(seleccion: Pais): Observable<Pais> {
    return this.http.put<Pais>(`${this.url}modificar`, seleccion);
  }

  public eliminar(idPais: number): Observable<boolean> {
    return this.http.delete<boolean>(`${this.url}eliminar/${idPais}`);
  }
}
