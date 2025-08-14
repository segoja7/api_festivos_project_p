import { Component } from '@angular/core';
import { ColumnMode, NgxDatatableModule, SelectionType } from '@swimlane/ngx-datatable';
import { Pais } from '../../../shared/entidades/pais';
import { PaisService } from '../../../core/servicios/pais.service';
import { MatDialog } from '@angular/material/dialog';
import { PaisEditarComponent } from '../pais-editar/pais-editar.component';
import { DecidirComponent } from '../../../shared/componentes/decidir/decidir.component';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-pais',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
    NgxDatatableModule,
  ],
  templateUrl: './pais.component.html',
  styleUrl: './pais.component.css'
})
export class PaisComponent {

  public textoBusqueda: string = "";
  public paises: Pais[] = [];
  public columnas = [
    { name: "Nombre", prop: "nombre" },
  ];
  public modoColumna = ColumnMode;
  public tipoSeleccion = SelectionType;

  public paisEscogido: Pais | undefined;
  public indicePaisEscogido: number = -1;

  constructor(private paisServicio: PaisService,
    public dialogServicio: MatDialog,
  ) {
  }

  ngOnInit(): void {
    this.listar();
  }

  escoger(event: any) {
    if (event.type == "click") {
      this.paisEscogido = event.row;
      this.indicePaisEscogido = this.paises.findIndex(seleccion => seleccion == this.paisEscogido);
    }
  }

  public listar() {
    this.paisServicio.listar().subscribe(
      {
        next: response => {
          this.paises = response;
        },
        error: error => {
          window.alert(error);
        }
      }
    );
  }

  public buscar() {
    if (this.textoBusqueda.length == 0) {
      this.listar();
    }
    else {
      this.paisServicio.buscar(this.textoBusqueda).subscribe({
        next: response => {
          this.paises = response;
        },
        error: error => {
          window.alert(error);
        }
      });
    }
  }
  agregar() {
    const dialogRef = this.dialogServicio.open(PaisEditarComponent, {
      width: '500px',
      height: '300px',
      data: {
        encabezado: "Agregando un nuevo País",
        pais: {
          id: 0,
          nombre: "",
        },
      },
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe({
      next: datos => {
        if (datos) {
          this.paisServicio.agregar(datos.pais).subscribe({
            next: response => {
              this.paisServicio.buscar(response.nombre).subscribe({
                next: response => {
                  this.paises = response;
                },
                error: error => {
                  window.alert(error);
                }
              });
            },
            error: error => {
              window.alert(error);
            }
          });
        }
      },
      error: error => {
        window.alert(error);
      }
    }
    );
  }
  modificar() {
    if (this.paisEscogido) {
      const dialogRef = this.dialogServicio.open(PaisEditarComponent, {
        width: '500px',
        height: '300px',
        data: {
          encabezado: `Editando el País [${this.paisEscogido.nombre}]`,
          pais: this.paisEscogido,
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.paisServicio.modificar(datos.pais).subscribe({
              next: response => {
                this.paises[this.indicePaisEscogido] = response;
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
      window.alert("Se debe elegir un País de la lista");
    }
  }
  verificarEliminar() {
    if (this.paisEscogido) {
      const dialogRef = this.dialogServicio.open(DecidirComponent, {
        width: "300px",
        height: "200px",
        data: {
          encabezado: `Está seguro de eliminar el País [${this.paisEscogido.nombre}]`,
          id: this.paisEscogido.id
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.paisServicio.eliminar(datos.id).subscribe({
              next: response => {
                if (response) {
                  this.listar();
                  window.alert("El País fue eliminada");
                }
                else {
                  window.alert("No se pudo eliminar el País");
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
      window.alert("Se debe elegir un País de la lista");
    }
  }

}
