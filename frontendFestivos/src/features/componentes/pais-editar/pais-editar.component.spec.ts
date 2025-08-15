import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PaisEditarComponent } from './pais-editar.component';

describe('PaisEditarComponent', () => {
  let component: PaisEditarComponent;
  let fixture: ComponentFixture<PaisEditarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PaisEditarComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PaisEditarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
