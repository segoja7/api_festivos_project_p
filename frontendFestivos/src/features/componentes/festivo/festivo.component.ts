import { Component } from '@angular/core';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { ColumnMode, NgxDatatableModule, SelectionType } from '@swimlane/ngx-datatable';
import { FormsModule } from '@angular/forms';
import { Festivo } from '../../../shared/entidades/festivo';
import { Tipo } from '../../../shared/entidades/tipo';
import { Pais } from '../../../shared/entidades/pais';
import { FestivoService } from '../../../core/servicios/festivo.service';
import { TipoService } from '../../../core/servicios/tipo.service';
import { MatDialog } from '@angular/material/dialog';
import { PaisService } from '../../../core/servicios/pais.service';
import { FestivoEditarComponent } from '../festivo-editar/festivo-editar.component';
import { DecidirComponent } from '../../../shared/componentes/decidir/decidir.component';
import { ListarFestivosComponent } from '../listar-festivos/listar-festivos.component';
import { VerificarFechaComponent } from '../verificar-fecha/verificar-fecha.component';

@Component({
  selector: 'app-festivo',
  standalone: true,
  imports: [
    ReferenciasMaterialModule,
    NgxDatatableModule,
    FormsModule
  ],
  templateUrl: './festivo.component.html',
  styleUrl: './festivo.component.css'
})
export class FestivoComponent {
  public textoBusqueda: string = "";
  public festivos: Festivo[] = [];
  public tipos: Tipo[] = [];
  public paises: Pais[] = [];

  public columnas = [
    { name: "Nombre", prop: "nombre" },
    { name: "Tipo", prop: "tipo.nombre" },
    { name: "País", prop: "pais.nombre" },
    { name: "Día", prop: "dia" },
    { name: "Mes", prop: "mes" },
    { name: "Días después de la Pascua", prop: "diasPascua" },
  ];
  public modoColumna = ColumnMode;
  public tipoSeleccion = SelectionType;

  public festivoEscogida: Festivo | undefined;
  public indiceFestivoEscogido: number = -1;

  constructor(private festivoServicio: FestivoService,
    private tipoServicio: TipoService,
    private paisServicio: PaisService,
    public dialogServicio: MatDialog,
  ) {
  }

  ngOnInit(): void {
    this.listar();
    this.listarTipos();
    this.listarPaises();
  }

  escoger(event: any) {
    if (event.type == "click") {
      this.festivoEscogida = event.row;
      this.indiceFestivoEscogido = this.festivos.findIndex(festivo => festivo == this.festivoEscogida);
    }
  }

  public listar() {
    this.festivoServicio.listar().subscribe(
      {
        next: response => {
          this.festivos = response;
        },
        error: error => {
          window.alert(error.message);
        }
      }
    );
  }

  public listarTipos() {
    this.tipoServicio.listar().subscribe(
      {
        next: response => {
          this.tipos = response;
        },
        error: error => {
          window.alert(error.message);
        }
      }
    );
  }

  public listarPaises() {
    this.paisServicio.listar().subscribe(
      {
        next: response => {
          this.paises = response;
        },
        error: error => {
          window.alert(error.message);
        }
      }
    );
  }

  public buscar() {
    if (this.textoBusqueda.length == 0) {
      this.listar();
    }
    else {
      this.festivoServicio.buscar(this.textoBusqueda).subscribe({
        next: response => {
          this.festivos = response;
        },
        error: error => {
          window.alert(error.message);
        }
      });
    }
  }
  agregar() {
    const dialogRef = this.dialogServicio.open(FestivoEditarComponent, {
      width: '500px',
      height: '400px',
      data: {
        encabezado: "Agregando un nuevo Festivo",
        festivo: {
          id: 0,
          nombre: "",
          pais: {
            id: 0, nombre: "",
          },
          tipo: {
            id: 0, nombre: "",
          },
          dia: 0,
          mes: 0,
          diasPascua: 0
        },
        tipos: this.tipos,
        paises: this.paises,
      },
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe({
      next: datos => {
        if (datos) {
          this.festivoServicio.agregar(datos.festivo).subscribe({
            next: response => {
              this.festivoServicio.buscar(response.nombre).subscribe({
                next: response => {
                  this.festivos = response;
                },
                error: error => {
                  window.alert(error.message);
                }
              });
            },
            error: error => {
              window.alert(error.message);
            }
          });
        }
      },
      error: error => {
        window.alert(error.message);
      }
    }
    );
  }
  modificar() {
    if (this.festivoEscogida) {
      const dialogRef = this.dialogServicio.open(FestivoEditarComponent, {
        width: '500px',
        height: '400px',
        data: {
          encabezado: `Editando el Festivo [${this.festivoEscogida.nombre}]`,
          festivo: this.festivoEscogida,
          tipos: this.tipos,
          paises: this.paises,
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.festivoServicio.modificar(datos.festivo).subscribe({
              next: response => {
                this.festivos[this.indiceFestivoEscogido] = response;
              },
              error: error => {
                window.alert(error.message);
              }
            });
          }
        }
      });
    }
    else {
      window.alert("Se debe elegir un Festivo de la lista");
    }
  }
  verificarEliminar() {
    if (this.festivoEscogida) {
      const dialogRef = this.dialogServicio.open(DecidirComponent, {
        width: "300px",
        height: "200px",
        data: {
          encabezado: `Está seguro de eliminar el Festivo [${this.festivoEscogida.nombre}]`,
          id: this.festivoEscogida.id
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.festivoServicio.eliminar(datos.id).subscribe({
              next: response => {
                if (response) {
                  this.listar();
                  window.alert("El Festivo fue eliminado");
                }
                else {
                  window.alert("No se pudo eliminar el Festivo");
                }
              },
              error: error => {
                window.alert(error.message);
              }
            });
          }
        }
      });
    }
    else {
      window.alert("Se debe elegir un Festivo de la lista");
    }
  }

  listarFechas() {
    const dialogRef = this.dialogServicio.open(ListarFestivosComponent, {
      width: "600px",
      height: "500px",
      data: {
        encabezado: `Listar Fechas Festivas por Año`,
        paises: this.paises,
      },
      disableClose: true,
    });
  }

  verificar() {
    const dialogRef = this.dialogServicio.open(VerificarFechaComponent, {
      width: "500px",
      height: "400px",
      data: {
        encabezado: `Verificar Fecha`,
        paises: this.paises,
      },
      disableClose: true,
    });
  }
}
